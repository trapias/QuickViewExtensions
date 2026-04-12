import Cocoa

/// Wraps CSV-rendered HTML table in a complete document with styling.
enum HTMLTemplate {

    static func wrap(_ bodyHTML: String, darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? systemIsDarkMode()

        return """
        <!DOCTYPE html>
        <html lang="en" data-theme="\(isDark ? "dark" : "light")">
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        \(css)
        </style>
        </head>
        <body class="\(isDark ? "dark" : "light")">
        \(bodyHTML)
        </body>
        </html>
        """
    }

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    private static let css = """
    /* ── Reset & Base ────────────────────────── */

    :root { color-scheme: light dark; }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
        font-size: 13px;
        line-height: 1.5;
        padding: 16px 20px;
        -webkit-font-smoothing: antialiased;
    }

    body.light { color: #1d1d1f; background-color: #ffffff; }
    body.dark { color: #e5e5e7; background-color: #1e1e1e; }

    /* ── Info Bar ────────────────────────────── */

    .csv-info {
        display: flex;
        gap: 8px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }

    .csv-badge {
        font-size: 11px;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: 500;
    }

    body.light .csv-badge { background: #f2f2f7; color: #636366; }
    body.dark .csv-badge { background: #2c2c2e; color: #a1a1a6; }

    body.light .csv-warning { background: #fff3cd; color: #856404; }
    body.dark .csv-warning { background: #3a3520; color: #ffc107; }

    /* ── Table ───────────────────────────────── */

    .csv-table-wrapper {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        border-radius: 8px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 12px;
        font-family: "SF Mono", SFMono-Regular, Menlo, monospace;
        white-space: nowrap;
    }

    th, td {
        padding: 6px 12px;
        text-align: left;
        max-width: 400px;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    body.light th, body.light td { border: 1px solid #e5e5ea; }
    body.dark th, body.dark td { border: 1px solid #3a3a3c; }

    /* Header */
    th {
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 1;
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
    }

    body.light th { background: #f2f2f7; color: #1d1d1f; }
    body.dark th { background: #2c2c2e; color: #e5e5e7; }

    /* Row number column */
    .csv-row-num {
        text-align: right;
        font-size: 10px;
        width: 40px;
        min-width: 40px;
    }

    body.light .csv-row-num { color: #aeaeb2; background: #fafafa; }
    body.dark .csv-row-num { color: #636366; background: #252528; }

    /* Alternating rows */
    body.light tbody tr:nth-child(even) { background: #fafafe; }
    body.dark tbody tr:nth-child(even) { background: #252528; }

    body.light tbody tr:hover { background: #e8f0fe; }
    body.dark tbody tr:hover { background: #1a3352; }

    /* Cell types */
    body.light .csv-number { color: #0550ae; text-align: right; }
    body.dark .csv-number { color: #79c0ff; text-align: right; }

    body.light .csv-bool { color: #cf222e; }
    body.dark .csv-bool { color: #ff7b72; }

    body.light .csv-empty { color: #c7c7cc; }
    body.dark .csv-empty { color: #48484a; }

    /* ── Error ───────────────────────────────── */

    .csv-error {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 16px 20px;
        border-radius: 10px;
        font-size: 14px;
    }

    body.light .csv-error { background: #fff2f2; border: 1px solid #ffcccc; color: #cc0000; }
    body.dark .csv-error { background: #3a1f1f; border: 1px solid #5c2020; color: #ff6961; }

    .csv-error-icon { font-size: 20px; }
    """
}
