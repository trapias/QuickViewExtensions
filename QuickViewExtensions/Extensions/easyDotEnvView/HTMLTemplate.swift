import Cocoa

enum HTMLTemplate {

    static func wrap(_ bodyHTML: String, darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <style>\(css)</style>
        </head>
        <body class="\(isDark ? "dark" : "light")">
        \(bodyHTML)
        </body>
        </html>
        """
    }

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    private static let css = """
    :root { color-scheme: light dark; }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
        font-family: "SF Mono", SFMono-Regular, Menlo, monospace;
        font-size: 13px; line-height: 1.6;
        padding: 16px 20px;
    }
    body.light { color: #1d1d1f; background: #ffffff; }
    body.dark { color: #e5e5e7; background: #1e1e1e; }

    .env-info { display: flex; gap: 8px; margin-bottom: 12px; }
    .env-badge {
        font-size: 11px; padding: 2px 8px; border-radius: 10px;
        font-weight: 500; font-family: -apple-system, sans-serif;
    }
    body.light .env-badge { background: #f2f2f7; color: #636366; }
    body.dark .env-badge { background: #2c2c2e; color: #a1a1a6; }
    body.light .env-warning { background: #fff3cd; color: #856404; }
    body.dark .env-warning { background: #3a3520; color: #ffc107; }

    .env-table { border-collapse: collapse; width: 100%; }
    .env-table td { padding: 3px 8px; vertical-align: top; }

    .env-key { font-weight: 600; white-space: nowrap; }
    body.light .env-key { color: #6f42c1; }
    body.dark .env-key { color: #d2a8ff; }

    .env-eq { width: 20px; text-align: center; }
    body.light .env-eq { color: #86868b; }
    body.dark .env-eq { color: #636366; }

    body.light .env-val { color: #0a7e3f; }
    body.dark .env-val { color: #7ee787; }

    .env-val-secret { letter-spacing: 2px; }
    body.light .env-val-secret { color: #cf222e; }
    body.dark .env-val-secret { color: #ff7b72; }

    .env-val-empty em { font-style: italic; }
    body.light .env-val-empty { color: #aeaeb2; }
    body.dark .env-val-empty { color: #636366; }

    .env-comment td { font-style: italic; }
    body.light .env-comment td { color: #86868b; }
    body.dark .env-comment td { color: #636366; }

    .env-empty td { height: 8px; }
    """
}
