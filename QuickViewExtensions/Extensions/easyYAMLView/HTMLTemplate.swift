import Cocoa

/// Wraps YAML content with syntax highlighting using highlight.js YAML mode.
enum HTMLTemplate {

    static func wrap(_ code: String, lineCount: Int, fileSize: Int,
                     darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()
        let theme = isDark ? "github-dark" : "github"
        let sizeStr = formatFileSize(fileSize)
        let escapedCode = escapeHTML(code)

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/styles/\(theme).min.css">
        <style>
        \(css)
        </style>
        </head>
        <body class="\(isDark ? "dark" : "light")">
        <div class="yaml-info">
            <span class="yaml-badge yaml-lang">YAML</span>
            <span class="yaml-badge">\(lineCount) lines</span>
            <span class="yaml-badge">\(sizeStr)</span>
        </div>
        <pre><code class="language-yaml">\(escapedCode)</code></pre>
        <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/highlight.min.js"></script>
        <script>hljs.highlightAll();</script>
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
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func formatFileSize(_ bytes: Int) -> String {
        if bytes < 1024 { return "\(bytes) B" }
        if bytes < 1024 * 1024 { return String(format: "%.1f KB", Double(bytes) / 1024) }
        return String(format: "%.1f MB", Double(bytes) / (1024 * 1024))
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

    .yaml-info {
        display: flex;
        gap: 8px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }

    .yaml-badge {
        font-size: 11px;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: 500;
    }

    body.light .yaml-badge { background: #f2f2f7; color: #636366; }
    body.dark .yaml-badge { background: #2c2c2e; color: #a1a1a6; }

    body.light .yaml-lang { background: #fce4ec; color: #c62828; font-weight: 600; }
    body.dark .yaml-lang { background: #3a1f1f; color: #ff7b72; font-weight: 600; }

    pre {
        border-radius: 10px;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        font-size: 13px;
        line-height: 1.6;
    }

    body.light pre { border: 1px solid #e5e5ea; }
    body.dark pre { border: 1px solid #3a3a3c; }

    pre code {
        font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        padding: 16px 20px;
        display: block;
    }

    .hljs { background: transparent !important; }
    """
}
