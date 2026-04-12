import Cocoa

/// Wraps SQL content with highlight.js SQL syntax highlighting.
enum HTMLTemplate {

    static func wrap(_ code: String, lineCount: Int, fileSize: Int,
                     darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()
        let theme = isDark ? "github-dark" : "github"
        let sizeStr = formatFileSize(fileSize)
        let escapedCode = escapeHTML(code)

        // Count SQL statements (rough: split on semicolons not in strings)
        let stmtCount = code.components(separatedBy: ";").count - 1

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/styles/\(theme).min.css">
        <style>\(css)</style>
        </head>
        <body class="\(isDark ? "dark" : "light")">
        <div class="sql-info">
            <span class="sql-badge sql-lang">SQL</span>
            <span class="sql-badge">\(lineCount) lines</span>
            <span class="sql-badge">\(stmtCount > 0 ? "\(stmtCount) statements" : "")</span>
            <span class="sql-badge">\(sizeStr)</span>
        </div>
        <pre><code class="language-sql">\(escapedCode)</code></pre>
        <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/highlight.min.js"></script>
        <script>hljs.highlightAll();</script>
        </body>
        </html>
        """
    }

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance ?? NSAppearance.currentDrawing()
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
        font-size: 13px; padding: 16px 20px;
    }
    body.light { color: #1d1d1f; background: #ffffff; }
    body.dark { color: #e5e5e7; background: #1e1e1e; }

    .sql-info { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
    .sql-badge {
        font-size: 11px; padding: 2px 8px; border-radius: 10px;
        font-weight: 500;
    }
    body.light .sql-badge { background: #f2f2f7; color: #636366; }
    body.dark .sql-badge { background: #2c2c2e; color: #a1a1a6; }
    body.light .sql-lang { background: #dbeafe; color: #1e40af; font-weight: 600; }
    body.dark .sql-lang { background: #1e3a5f; color: #93c5fd; font-weight: 600; }

    pre {
        border-radius: 10px; overflow-x: auto;
        font-size: 13px; line-height: 1.6;
    }
    body.light pre { border: 1px solid #e5e5ea; }
    body.dark pre { border: 1px solid #3a3a3c; }
    pre code {
        font-family: "SF Mono", SFMono-Regular, Menlo, monospace;
        padding: 16px 20px; display: block;
    }
    .hljs { background: transparent !important; }
    """
}
