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

1. Open the `.dmg` file
2. Drag **QuickViewExtensions** to the **Applications** folder
3. Right-click the app and select **Open** (required for unsigned apps)
4. The extensions activate automatically after first launch

### From source

```bash
cd QuickViewExtensions
./scripts/install.sh
```

Requires Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

## Managing Extensions

Extensions can be individually enabled or disabled in:

**System Settings → General → Login Items & Extensions → QuickViewExtensions**

## Build

```bash
cd QuickViewExtensions
xcodegen generate
xcodebuild -project QuickViewExtensions.xcodeproj -scheme QuickViewExtensions -configuration Release build
```

### Create DMG

```bash
./scripts/build-dmg.sh
```

## Requirements

- macOS 15.0 (Sequoia) or later
- No Apple Developer account required (uses local signing)

## Architecture

The project uses a host app + app extension pattern:

```
QuickViewExtensions.app
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
