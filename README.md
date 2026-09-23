# QuickViewExtensions

Quick Look preview extensions for macOS. Press **Space** on any supported file in Finder to see a beautifully formatted preview.

## Extensions

| Extension | File Types | Description |
|-----------|-----------|-------------|
| **easyMDView** | `.md` | Markdown with full CSS styling and Mermaid diagram support |
| **easyJSONView** | `.json` | Collapsible tree view with syntax highlighting |
| **easyCodeView** | `.swift` `.py` `.js` `.ts` `.cs` `.razor` `.go` `.rs` + 40 others | Syntax highlighting via highlight.js with line numbers |
| **easyYAMLView** | `.yaml` `.yml` | YAML syntax highlighting |
| **easyDotEnvView** | `.env` | Key-value display with automatic secret masking |
| **easyLogView** | `.log` | Color-coded severity levels (ERROR, WARN, INFO, DEBUG) |

All extensions support **light and dark mode** automatically.

## Installation

### From DMG

1. Open `easyQuickView.dmg` and drag **easyQuickView.app** into **Applications**.
2. Open **easyQuickView** once to register its Quick Look extensions. If macOS blocks it, open **System Settings → Privacy & Security** and choose **Open Anyway** for easyQuickView, then confirm. This option appears after an attempted launch and is available for about an hour.
3. Close the app and select a supported file in Finder, then press **Space**.

The DMG is not notarized. Only if you trust the copy you received and macOS still blocks it, you can remove the quarantine attribute from the installed app and try opening it again:

```bash
xattr -dr com.apple.quarantine /Applications/easyQuickView.app
```

Removing quarantine does not repair a damaged app or an invalid code signature. The current build uses an Apple Development signature; installation on another Mac must be tested before distributing the DMG more widely. A Developer ID signature and notarization are the supported distribution path.

### From source

```bash
cd QuickViewExtensions
./scripts/install.sh
```

Requires Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

## Managing Extensions

Extensions can be individually enabled or disabled in:

**System Settings → General → Login Items & Extensions → easyQuickView**

## Build

```bash
cd QuickViewExtensions
xcodegen generate
xcodebuild -project easyQuickView.xcodeproj -scheme easyQuickView -configuration Release build
```

### Create DMG

```bash
./scripts/build-dmg.sh
```

## Requirements

- macOS 15.0 (Sequoia) or later
- The current project is configured for Apple Development signing; building requires a matching signing identity.

## Architecture

The project uses a host app + app extension pattern:

```
easyQuickView.app
└── Contents/PlugIns/
    ├── easyMDView.appex
    ├── easyJSONView.appex
    ├── easyCodeView.appex
    ├── easyYAMLView.appex
    ├── easyDotEnvView.appex
    └── easyLogView.appex
```

Each extension implements `QLPreviewingController` and returns HTML content via `QLPreviewReply`. The host app is a minimal SwiftUI app that lists the extensions and triggers macOS to register them.

**Build system**: [XcodeGen](https://github.com/yonaskolb/XcodeGen) generates the Xcode project from `project.yml`.

## License

MIT

## Support

- [Website](https://mac.trapias.it)
- [Buy me a coffee](https://buymeacoffee.com/trapias)
