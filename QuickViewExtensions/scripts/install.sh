#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="QuickViewExtensions"
BUNDLE_ID="it.trapias.easyQuickView"
BUILD_DIR="${PROJECT_DIR}/build"
INSTALL_DIR="/Applications"

echo "==> Generating Xcode project..."
cd "${PROJECT_DIR}"
xcodegen generate

echo "==> Building Debug..."
xcodebuild \
    -project "${APP_NAME}.xcodeproj" \
    -scheme "${APP_NAME}" \
    -configuration Debug \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    build 2>&1 | tail -5

APP_PATH="${BUILD_DIR}/DerivedData/Build/Products/Debug/${APP_NAME}.app"
if [ ! -d "${APP_PATH}" ]; then
    echo "ERROR: Build failed — app not found at ${APP_PATH}"
    exit 1
fi

echo "==> Installing to ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"
rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
cp -R "${APP_PATH}" "${INSTALL_DIR}/"

echo "==> Registering with LaunchServices..."
/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister \
    -f -R -trusted "${INSTALL_DIR}/${APP_NAME}.app"

echo "==> Resetting Quick Look cache..."
qlmanage -r 2>&1 | head -1
qlmanage -r cache 2>&1 | head -1

echo "==> Launching app to register extensions..."
open "${INSTALL_DIR}/${APP_NAME}.app"
sleep 2

echo "==> Enabling all Quick Look extensions..."
EXTENSIONS=(easyMDView easyJSONView easyCodeView easyYAMLView easyDotEnvView easyLogView)
for ext in "${EXTENSIONS[@]}"; do
    pluginkit -e use -i "${BUNDLE_ID}.${ext}" 2>/dev/null || true
done

echo ""
echo "==> Done! ${APP_NAME} installed at ${INSTALL_DIR}/${APP_NAME}.app"
echo "    Press Space on any supported file in Finder to test."
echo "    Supported: .md .json .swift .py .js .cs .yaml .env .log .sql"
