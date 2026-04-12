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
        font-size: 12px; line-height: 1.5;
        padding: 16px 20px;
    }
    body.light { color: #1d1d1f; background: #ffffff; }
    body.dark { color: #e5e5e7; background: #1e1e1e; }

    .log-info { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
    .log-badge {
        font-size: 11px; padding: 2px 8px; border-radius: 10px;
        font-weight: 500; font-family: -apple-system, sans-serif;
    }
    body.light .log-badge { background: #f2f2f7; color: #636366; }
    body.dark .log-badge { background: #2c2c2e; color: #a1a1a6; }

    body.light .log-b-error { background: #fee2e2; color: #dc2626; font-weight: 600; }
    body.dark .log-b-error { background: #3a1f1f; color: #ff6961; font-weight: 600; }

    body.light .log-b-warn { background: #fff3cd; color: #856404; font-weight: 600; }
    body.dark .log-b-warn { background: #3a3520; color: #ffc107; font-weight: 600; }

    body.light .log-trunc { background: #e8f0fe; color: #1a73e8; }
    body.dark .log-trunc { background: #1a3352; color: #79c0ff; }

    .log-content {
        border-radius: 10px; padding: 12px 16px; overflow-x: auto;
    }
    body.light .log-content { background: #fafafa; border: 1px solid #e5e5ea; }
    body.dark .log-content { background: #252528; border: 1px solid #3a3a3c; }

    .log-line { padding: 1px 0; white-space: pre-wrap; word-break: break-all; }

    body.light .error { color: #dc2626; font-weight: 500; }
    body.dark .error { color: #ff6961; font-weight: 500; }

    body.light .warn { color: #d97706; }
    body.dark .warn { color: #fbbf24; }

    body.light .info { color: #2563eb; }
    body.dark .info { color: #60a5fa; }

    body.light .debug { color: #86868b; }
    body.dark .debug { color: #636366; }

    body.light .trace { color: #aeaeb2; }
    body.dark .trace { color: #48484a; }

    body.light .log-plain { color: #1d1d1f; }
    body.dark .log-plain { color: #e5e5e7; }
    """
}
