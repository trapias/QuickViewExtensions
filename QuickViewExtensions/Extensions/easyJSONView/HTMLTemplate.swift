import Cocoa

/// Wraps JSON-rendered HTML in a complete document with styling for
/// syntax highlighting, collapsible tree, and light/dark mode.
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
        <article>
        \(bodyHTML)
        </article>
        </body>
        </html>
        """
    }

    // MARK: - Appearance Detection

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    // MARK: - CSS

    private static let css = """
    /* ── Reset & Base ────────────────────────── */

    :root {
        color-scheme: light dark;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
        font-size: 13px;
        line-height: 1.6;
        padding: 20px 24px;
        -webkit-font-smoothing: antialiased;
    }

    body.light {
        color: #1d1d1f;
        background-color: #ffffff;
    }

    body.dark {
        color: #e5e5e7;
        background-color: #1e1e1e;
    }

    article {
        max-width: 960px;
        margin: 0 auto;
    }

    /* ── JSON Tree ───────────────────────────── */

    .json-tree {
        font-size: 13px;
    }

    .json-indent {
        margin-left: 20px;
        padding-left: 12px;
    }

    body.light .json-indent {
        border-left: 1px solid #e5e5ea;
    }

    body.dark .json-indent {
        border-left: 1px solid #3a3a3c;
    }

    .json-entry {
        padding: 1px 0;
    }

    /* ── Collapsible Nodes ───────────────────── */

    details {
        display: inline;
    }

    details > summary {
        cursor: pointer;
        list-style: none;
        display: inline;
        user-select: none;
    }

    details > summary::-webkit-details-marker {
        display: none;
    }

    details > summary::before {
        content: "▶ ";
        font-size: 10px;
        margin-right: 2px;
        display: inline-block;
        transition: transform 0.15s ease;
    }

    details[open] > summary::before {
        content: "▼ ";
    }

    details > summary:hover {
        opacity: 0.7;
    }

    /* ── Syntax Colors ───────────────────────── */

    /* Keys */
    body.light .json-key { color: #6f42c1; }
    body.dark .json-key { color: #d2a8ff; }

    /* Strings */
    body.light .json-string { color: #0a7e3f; }
    body.dark .json-string { color: #7ee787; }

    /* Numbers */
    body.light .json-number { color: #0550ae; }
    body.dark .json-number { color: #79c0ff; }

    /* Booleans */
    body.light .json-bool { color: #cf222e; }
    body.dark .json-bool { color: #ff7b72; }

    /* Null */
    body.light .json-null { color: #86868b; font-style: italic; }
    body.dark .json-null { color: #8e8e93; font-style: italic; }

    /* Braces & Brackets */
    body.light .json-brace,
    body.light .json-bracket { color: #1d1d1f; font-weight: 600; }
    body.dark .json-brace,
    body.dark .json-bracket { color: #e5e5e7; font-weight: 600; }

    /* Colon & Comma */
    body.light .json-colon,
    body.light .json-comma { color: #86868b; }
    body.dark .json-colon,
    body.dark .json-comma { color: #8e8e93; }

    /* Item count badge */
    .json-count {
        font-size: 11px;
        padding: 1px 6px;
        border-radius: 8px;
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
    }

    body.light .json-count {
        color: #636366;
        background-color: #f2f2f7;
    }

    body.dark .json-count {
        color: #a1a1a6;
        background-color: #2c2c2e;
    }

    /* Array index */
    .json-index {
        font-size: 11px;
    }

    body.light .json-index { color: #86868b; }
    body.dark .json-index { color: #636366; }

    /* ── Error Panel ─────────────────────────── */

    .json-error {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 16px 20px;
        border-radius: 10px;
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
        font-size: 14px;
    }

    body.light .json-error {
        background-color: #fff2f2;
        border: 1px solid #ffcccc;
        color: #cc0000;
    }

    body.dark .json-error {
        background-color: #3a1f1f;
        border: 1px solid #5c2020;
        color: #ff6961;
    }

    .json-error-icon {
        font-size: 20px;
    }
    """
}
