import Cocoa

/// Wraps source code in HTML with highlight.js syntax highlighting,
/// line numbers, and file metadata.
enum HTMLTemplate {

    static func wrap(_ code: String, language: String, extension ext: String,
                     lineCount: Int, fileSize: Int, darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()
        let langName = LanguageMap.displayName(for: ext)
        let sizeStr = formatFileSize(fileSize)
        let theme = isDark ? "github-dark" : "github"

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
        <div class="code-info">
            <span class="code-badge code-lang">\(langName)</span>
            <span class="code-badge">\(lineCount) lines</span>
            <span class="code-badge">\(sizeStr)</span>
        </div>
        <pre><code class="language-\(language)">\(escapedCode)</code></pre>
        <script src="https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/highlight.min.js"></script>
        <script>
        hljs.highlightAll();
        // Add line numbers after highlighting
        document.querySelectorAll('pre code').forEach(function(block) {
            var lines = block.textContent.split('\\n');
            if (lines[lines.length - 1].trim() === '') lines.pop();
            var numbered = lines.map(function(line, i) {
                var span = document.createElement('span');
                span.className = 'line-num';
                span.textContent = (i + 1).toString();
                return span.outerHTML + escLine(line);
            }).join('\\n');
            block.textContent = '';
            block.insertAdjacentHTML('afterbegin', numbered);
        });
        function escLine(s) {
            return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
        }
        </script>
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

    .code-info {
        display: flex;
        gap: 8px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }

    .code-badge {
        font-size: 11px;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: 500;
    }

    body.light .code-badge { background: #f2f2f7; color: #636366; }
    body.dark .code-badge { background: #2c2c2e; color: #a1a1a6; }

    body.light .code-lang { background: #e8f0fe; color: #1a73e8; font-weight: 600; }
    body.dark .code-lang { background: #1a3352; color: #79c0ff; font-weight: 600; }

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

    .line-num {
        display: inline-block;
        width: 3.5em;
        text-align: right;
        margin-right: 16px;
        -webkit-user-select: none;
        user-select: none;
    }

    body.light .line-num { color: #c7c7cc; }
    body.dark .line-num { color: #48484a; }

    .hljs { background: transparent !important; }
    """
}
