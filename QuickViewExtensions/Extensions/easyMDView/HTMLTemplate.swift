import Cocoa

/// Wraps HTML content in a complete document with full CSS styling.
/// Since QLIsDataBasedPreview=true, Quick Look renders this as real HTML
/// with full CSS and JavaScript support.
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
        \(mermaidScript)
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

    // MARK: - Mermaid.js

    private static let mermaidScript = """
    <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const theme = document.body.classList.contains('dark') ? 'dark' : 'default';
        mermaid.initialize({
            startOnLoad: true,
            theme: theme,
            securityLevel: 'loose'
        });
    });
    </script>
    """

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
        font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 15px;
        line-height: 1.75;
        padding: 28px 36px;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
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
        max-width: 820px;
        margin: 0 auto;
    }

    /* ── Headings ────────────────────────────── */

    h1, h2, h3, h4, h5, h6 {
        font-weight: 600;
        line-height: 1.3;
        margin-top: 2em;
        margin-bottom: 0.75em;
    }

    h1 {
        font-size: 2em;
        font-weight: 700;
        padding-bottom: 0.4em;
        margin-top: 0;
    }

    body.light h1 { border-bottom: 2px solid #d1d1d6; }
    body.dark h1 { border-bottom: 2px solid #3a3a3c; }

    h2 {
        font-size: 1.5em;
        padding-bottom: 0.3em;
    }

    body.light h2 { border-bottom: 1px solid #e5e5ea; }
    body.dark h2 { border-bottom: 1px solid #3a3a3c; }

    h3 { font-size: 1.25em; }
    h4 { font-size: 1.1em; }

    h5 {
        font-size: 1em;
        font-weight: 600;
    }
    body.light h5 { color: #6e6e73; }
    body.dark h5 { color: #a1a1a6; }

    h6 {
        font-size: 0.875em;
        font-weight: 600;
    }
    body.light h6 { color: #86868b; }
    body.dark h6 { color: #8e8e93; }

    /* ── Paragraphs ──────────────────────────── */

    p {
        margin-bottom: 1em;
    }

    /* ── Links ───────────────────────────────── */

    body.light a { color: #0066cc; }
    body.dark a { color: #4db8ff; }

    a {
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }

    /* ── Inline Code ─────────────────────────── */

    code {
        font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
        font-size: 0.875em;
        padding: 0.2em 0.45em;
        border-radius: 5px;
    }

    body.light code {
        background-color: #f2f2f7;
        color: #e8233a;
    }

    body.dark code {
        background-color: #2c2c2e;
        color: #ff6961;
    }

    /* ── Code Blocks ─────────────────────────── */

    pre {
        margin-top: 0.5em;
        margin-bottom: 1.5em;
        padding: 16px 20px;
        border-radius: 10px;
        overflow-x: auto;
        line-height: 1.55;
        -webkit-overflow-scrolling: touch;
    }

    body.light pre {
        background-color: #f2f2f7;
        border: 1px solid #e5e5ea;
    }

    body.dark pre {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
    }

    pre code {
        background: none;
        padding: 0;
        border-radius: 0;
        font-size: 0.85em;
        color: inherit;
    }

    /* ── Blockquotes ─────────────────────────── */

    blockquote {
        margin: 0 0 1em 0;
        padding: 0.6em 1em;
        border-left: 4px solid;
        border-radius: 0 6px 6px 0;
    }

    body.light blockquote {
        border-left-color: #0066cc;
        background-color: #f2f2f7;
        color: #636366;
    }

    body.dark blockquote {
        border-left-color: #4db8ff;
        background-color: #2c2c2e;
        color: #a1a1a6;
    }

    blockquote p:last-child {
        margin-bottom: 0;
    }

    /* ── Lists ───────────────────────────────── */

    ul, ol {
        margin-bottom: 1em;
        padding-left: 2em;
    }

    li {
        margin-bottom: 0.35em;
    }

    li > ul, li > ol {
        margin-bottom: 0;
        margin-top: 0.35em;
    }

    /* ── Task Lists ──────────────────────────── */

    .task-list-item {
        list-style: none;
        margin-left: -1.5em;
    }

    .task-list-item input[type="checkbox"] {
        margin-right: 0.5em;
        vertical-align: middle;
    }

    /* ── Tables ──────────────────────────────── */

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 0.5em;
        margin-bottom: 1.5em;
        font-size: 0.92em;
        border-radius: 8px;
        overflow: hidden;
    }

    th, td {
        padding: 10px 14px;
        text-align: left;
    }

    body.light th, body.light td { border: 1px solid #e5e5ea; }
    body.dark th, body.dark td { border: 1px solid #3a3a3c; }

    th {
        font-weight: 600;
    }

    body.light th { background-color: #f2f2f7; }
    body.dark th { background-color: #2c2c2e; }

    body.light tbody tr:nth-child(even) { background-color: #fafafe; }
    body.dark tbody tr:nth-child(even) { background-color: #252528; }

    body.light tbody tr:hover { background-color: #f2f2f7; }
    body.dark tbody tr:hover { background-color: #2c2c2e; }

    /* ── Horizontal Rule ─────────────────────── */

    hr {
        border: none;
        margin: 2em 0;
        height: 1px;
    }

    body.light hr { background-color: #d1d1d6; }
    body.dark hr { background-color: #3a3a3c; }

    /* ── Images ──────────────────────────────── */

    img {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        margin: 0.5em 0;
    }

    /* ── Emphasis & Misc ─────────────────────── */

    strong { font-weight: 600; }

    body.light del { color: #86868b; }
    body.dark del { color: #8e8e93; }

    /* ── Mermaid Diagrams ────────────────────── */

    .mermaid {
        margin: 1.5em 0;
        text-align: center;
    }

    pre.language-mermaid,
    pre > code.language-mermaid {
        background: none;
        border: none;
        padding: 0;
    }
    """
}
