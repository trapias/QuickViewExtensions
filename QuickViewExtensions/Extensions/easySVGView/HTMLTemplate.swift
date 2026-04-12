import Cocoa

/// Wraps SVG content in an HTML document with a checkerboard background
/// (to show transparency) and an info bar with SVG metadata.
enum HTMLTemplate {

    static func wrap(_ svgContent: String, info: SVGAnalyzer.SVGInfo, darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()

        var badges = "<span class=\"svg-badge\">\(info.fileSize)</span>"

        if let w = info.width, let h = info.height {
            badges += "<span class=\"svg-badge\">\(escapeHTML(w)) × \(escapeHTML(h))</span>"
        } else if let vb = info.viewBox {
            badges += "<span class=\"svg-badge\">viewBox: \(escapeHTML(vb))</span>"
        }

        badges += "<span class=\"svg-badge\">\(info.elementCount) elements</span>"

        if info.hasText { badges += "<span class=\"svg-badge svg-feature\">Text</span>" }
        if info.hasGradients { badges += "<span class=\"svg-badge svg-feature\">Gradients</span>" }
        if info.hasFilters { badges += "<span class=\"svg-badge svg-feature\">Filters</span>" }
        if info.hasAnimations { badges += "<span class=\"svg-badge svg-feature\">Animated</span>" }

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        \(css)
        </style>
        </head>
        <body class="\(isDark ? "dark" : "light")">
        <div class="svg-info">\(badges)</div>
        <div class="svg-canvas">
            <div class="svg-container">
            \(svgContent)
            </div>
        </div>
        </body>
        </html>
        """
    }

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }

    private static let css = """
    :root { color-scheme: light dark; }
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
        font-size: 13px;
        padding: 16px 20px;
        -webkit-font-smoothing: antialiased;
    }

    body.light { color: #1d1d1f; background: #ffffff; }
    body.dark { color: #e5e5e7; background: #1e1e1e; }

    /* ── Info Bar ────────────────────────────── */

    .svg-info {
        display: flex;
        gap: 8px;
        margin-bottom: 16px;
        flex-wrap: wrap;
    }

    .svg-badge {
        font-size: 11px;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: 500;
    }

    body.light .svg-badge { background: #f2f2f7; color: #636366; }
    body.dark .svg-badge { background: #2c2c2e; color: #a1a1a6; }

    body.light .svg-feature { background: #e8f0fe; color: #1a73e8; }
    body.dark .svg-feature { background: #1a3352; color: #79c0ff; }

    /* ── SVG Canvas ──────────────────────────── */

    .svg-canvas {
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 10px;
        padding: 24px;
        min-height: 200px;
        /* Checkerboard pattern for transparency */
        background-image:
            linear-gradient(45deg, #ccc 25%, transparent 25%),
            linear-gradient(-45deg, #ccc 25%, transparent 25%),
            linear-gradient(45deg, transparent 75%, #ccc 75%),
            linear-gradient(-45deg, transparent 75%, #ccc 75%);
        background-size: 16px 16px;
        background-position: 0 0, 0 8px, 8px -8px, -8px 0px;
    }

    body.light .svg-canvas {
        background-color: #ffffff;
        border: 1px solid #e5e5ea;
    }

    body.dark .svg-canvas {
        background-color: #2c2c2e;
        background-image:
            linear-gradient(45deg, #3a3a3c 25%, transparent 25%),
            linear-gradient(-45deg, #3a3a3c 25%, transparent 25%),
            linear-gradient(45deg, transparent 75%, #3a3a3c 75%),
            linear-gradient(-45deg, transparent 75%, #3a3a3c 75%);
        border: 1px solid #3a3a3c;
    }

    .svg-container {
        max-width: 100%;
        max-height: 70vh;
        display: flex;
        justify-content: center;
    }

    .svg-container svg {
        max-width: 100%;
        max-height: 70vh;
        height: auto;
        width: auto;
    }
    """
}
