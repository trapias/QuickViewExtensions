import Foundation

/// Wraps HTML content in a complete document with styling.
enum HTMLTemplate {

    /// Wrap an HTML body fragment in a full HTML document with CSS.
    static func wrap(_ bodyHTML: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        \(css)
        </style>
        </head>
        <body>
        <article>
        \(bodyHTML)
        </article>
        </body>
        </html>
        """
    }

    private static let css = """
    :root {
        color-scheme: light dark;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 15px;
        line-height: 1.7;
        color: #1d1d1f;
        background: #ffffff;
        padding: 24px 32px;
        -webkit-font-smoothing: antialiased;
    }

    @media (prefers-color-scheme: dark) {
        body {
            color: #f5f5f7;
            background: #1d1d1f;
        }
    }

    article {
        max-width: 780px;
        margin: 0 auto;
    }

    /* Headings */
    h1, h2, h3, h4, h5, h6 {
        margin-top: 1.4em;
        margin-bottom: 0.6em;
        font-weight: 600;
        line-height: 1.3;
    }

    h1 { font-size: 2em; border-bottom: 1px solid #d2d2d7; padding-bottom: 0.3em; }
    h2 { font-size: 1.5em; border-bottom: 1px solid #d2d2d7; padding-bottom: 0.2em; }
    h3 { font-size: 1.25em; }
    h4 { font-size: 1.1em; }
    h5 { font-size: 1em; }
    h6 { font-size: 0.9em; color: #86868b; }

    @media (prefers-color-scheme: dark) {
        h1, h2 { border-bottom-color: #424245; }
        h6 { color: #a1a1a6; }
    }

    h1:first-child, h2:first-child, h3:first-child {
        margin-top: 0;
    }

    /* Paragraphs */
    p {
        margin-bottom: 1em;
    }

    /* Links */
    a {
        color: #0066cc;
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }

    @media (prefers-color-scheme: dark) {
        a { color: #2997ff; }
    }

    /* Inline code */
    code {
        font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        font-size: 0.88em;
        background: #f5f5f7;
        padding: 0.15em 0.4em;
        border-radius: 4px;
    }

    @media (prefers-color-scheme: dark) {
        code { background: #2c2c2e; }
    }

    /* Code blocks */
    pre {
        margin-bottom: 1em;
        padding: 16px;
        background: #f5f5f7;
        border-radius: 8px;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    pre code {
        background: none;
        padding: 0;
        font-size: 0.85em;
        line-height: 1.5;
    }

    @media (prefers-color-scheme: dark) {
        pre { background: #2c2c2e; }
    }

    /* Blockquotes */
    blockquote {
        margin-bottom: 1em;
        padding: 0.5em 1em;
        border-left: 4px solid #d2d2d7;
        color: #6e6e73;
    }

    blockquote p:last-child {
        margin-bottom: 0;
    }

    @media (prefers-color-scheme: dark) {
        blockquote {
            border-left-color: #424245;
            color: #a1a1a6;
        }
    }

    /* Lists */
    ul, ol {
        margin-bottom: 1em;
        padding-left: 2em;
    }

    li {
        margin-bottom: 0.3em;
    }

    li > ul, li > ol {
        margin-bottom: 0;
        margin-top: 0.3em;
    }

    /* Task list */
    .task-list-item {
        list-style: none;
        margin-left: -1.5em;
    }

    .task-list-item input[type="checkbox"] {
        margin-right: 0.4em;
        vertical-align: middle;
    }

    /* Tables */
    table {
        width: 100%;
        margin-bottom: 1em;
        border-collapse: collapse;
        font-size: 0.92em;
    }

    th, td {
        padding: 8px 12px;
        border: 1px solid #d2d2d7;
        text-align: left;
    }

    th {
        background: #f5f5f7;
        font-weight: 600;
    }

    tbody tr:nth-child(even) {
        background: #fafafa;
    }

    @media (prefers-color-scheme: dark) {
        th, td { border-color: #424245; }
        th { background: #2c2c2e; }
        tbody tr:nth-child(even) { background: #242426; }
    }

    /* Horizontal rule */
    hr {
        margin: 1.5em 0;
        border: none;
        border-top: 1px solid #d2d2d7;
    }

    @media (prefers-color-scheme: dark) {
        hr { border-top-color: #424245; }
    }

    /* Images */
    img {
        max-width: 100%;
        height: auto;
        border-radius: 4px;
    }

    /* Strong & Em */
    strong { font-weight: 600; }

    /* Strikethrough */
    del { color: #86868b; }

    @media (prefers-color-scheme: dark) {
        del { color: #a1a1a6; }
    }
    """
}
