#!/bin/bash
set -euo pipefail

# Build configuration
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="QuickViewExtensions"
BUILD_DIR="${PROJECT_DIR}/build"
DMG_DIR="${BUILD_DIR}/dmg"
OUTPUT_DMG="${BUILD_DIR}/${APP_NAME}.dmg"

echo "==> Cleaning previous builds..."
rm -rf "${BUILD_DIR}"
mkdir -p "${DMG_DIR}"

echo "==> Generating Xcode project..."
cd "${PROJECT_DIR}"
xcodegen generate

echo "==> Building Release..."
xcodebuild \
    -project "${APP_NAME}.xcodeproj" \
    -scheme "${APP_NAME}" \
    -configuration Release \
    -derivedDataPath "${BUILD_DIR}/DerivedData" \
    build

# Find the built .app
APP_PATH=$(find "${BUILD_DIR}/DerivedData" -name "${APP_NAME}.app" -type d | head -1)

if [ -z "${APP_PATH}" ]; then
    echo "ERROR: Could not find built .app"
    exit 1
fi

echo "==> Found app at: ${APP_PATH}"

# Copy .app to DMG staging
cp -R "${APP_PATH}" "${DMG_DIR}/"

# Create a symlink to /Applications for drag-and-drop install
ln -s /Applications "${DMG_DIR}/Applications"

echo "==> Creating DMG..."
hdiutil create \
    -volname "${APP_NAME}" \
    -srcfolder "${DMG_DIR}" \
    -ov \
    -format UDZO \
    "${OUTPUT_DMG}"

echo ""
echo "==> Done! DMG created at:"
echo "    ${OUTPUT_DMG}"
echo ""
echo "NOTE: This app is not notarized. On the target Mac:"
echo "  1. Open the DMG and drag the app to Applications"
echo "  2. Right-click the app > Open (first time only, to bypass Gatekeeper)"
echo "  3. The Quick Look extension activates automatically after first launch"
