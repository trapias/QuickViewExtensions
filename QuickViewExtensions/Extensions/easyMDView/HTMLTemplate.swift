import Cocoa

/// Wraps HTML content in a complete document with styling.
/// Detects system appearance and injects the appropriate CSS.
enum HTMLTemplate {

    /// Wrap an HTML body fragment in a full HTML document with CSS.
    static func wrap(_ bodyHTML: String, darkMode: Bool? = nil) -> String {
        let isDark = darkMode ?? Self.systemIsDarkMode()
        let colors = isDark ? Colors.dark : Colors.light

        return """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <style>
        \(css(with: colors))
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

    // MARK: - Appearance Detection

    private static func systemIsDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    // MARK: - Color Palette

    private struct Colors {
        let bg: String
        let text: String
        let textSecondary: String
        let textTertiary: String
        let link: String
        let border: String
        let codeBg: String
        let tableBgAlt: String
        let tableHeaderBg: String
        let blockquoteBorder: String
        let blockquoteText: String

        static let light = Colors(
            bg: "#ffffff",
            text: "#1d1d1f",
            textSecondary: "#6e6e73",
            textTertiary: "#86868b",
            link: "#0066cc",
            border: "#d2d2d7",
            codeBg: "#f5f5f7",
            tableBgAlt: "#f9f9fb",
            tableHeaderBg: "#f0f0f5",
            blockquoteBorder: "#0066cc",
            blockquoteText: "#6e6e73"
        )

        static let dark = Colors(
            bg: "#1e1e1e",
            text: "#e5e5e7",
            textSecondary: "#a1a1a6",
            textTertiary: "#86868b",
            link: "#4db8ff",
            border: "#3a3a3c",
            codeBg: "#2c2c2e",
            tableBgAlt: "#252528",
            tableHeaderBg: "#2c2c2e",
            blockquoteBorder: "#4db8ff",
            blockquoteText: "#a1a1a6"
        )
    }

    // MARK: - CSS

    private static func css(with c: Colors) -> String {
        """
        body {
            font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14px;
            line-height: 1.7;
            color: \(c.text);
            background-color: \(c.bg);
        }

        article {
            max-width: 780px;
        }

        /* ── Headings ────────────────────────────── */

        h1, h2, h3, h4, h5, h6 {
            color: \(c.text);
            margin-top: 2em;
            margin-bottom: 0.7em;
            font-weight: 700;
            line-height: 1.3;
        }

        h1 {
            font-size: 1.9em;
            margin-top: 2.2em;
            border-bottom: 2px solid \(c.border);
            padding-bottom: 0.35em;
        }

        h2 {
            font-size: 1.45em;
            margin-top: 2em;
            border-bottom: 1px solid \(c.border);
            padding-bottom: 0.25em;
        }

        h3 { font-size: 1.2em; margin-top: 1.8em; }
        h4 { font-size: 1.05em; margin-top: 1.6em; }
        h5 { font-size: 1em; color: \(c.textSecondary); }
        h6 { font-size: 0.9em; color: \(c.textTertiary); }

        /* ── Paragraphs ──────────────────────────── */

        p {
            margin-top: 0;
            margin-bottom: 0.9em;
        }

        /* ── Links ───────────────────────────────── */

        a {
            color: \(c.link);
        }

        /* ── Code ────────────────────────────────── */

        code {
            font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 0.88em;
            background-color: \(c.codeBg);
            padding: 2px 5px;
        }

        pre {
            background-color: \(c.codeBg);
            padding: 14px;
            margin-top: 0.5em;
            margin-bottom: 1.4em;
            font-family: "SF Mono", SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 12px;
            line-height: 1.55;
            color: \(c.text);
            border: 1px solid \(c.border);
        }

        pre code {
            background-color: transparent;
            padding: 0;
            font-size: inherit;
        }

        /* ── Blockquotes ─────────────────────────── */

        blockquote {
            margin-left: 0;
            margin-right: 0;
            margin-top: 0;
            margin-bottom: 1em;
            padding-left: 16px;
            border-left: 4px solid \(c.blockquoteBorder);
            color: \(c.blockquoteText);
        }

        /* ── Lists ───────────────────────────────── */

        ul, ol {
            margin-bottom: 1em;
            padding-left: 1.8em;
        }

        li {
            margin-bottom: 0.25em;
        }

        /* ── Tables ──────────────────────────────── */

        table {
            border-collapse: collapse;
            margin-top: 0.5em;
            margin-bottom: 1.4em;
            font-size: 0.92em;
        }

        th, td {
            padding: 7px 12px;
            border: 1px solid \(c.border);
            text-align: left;
        }

        th {
            background-color: \(c.tableHeaderBg);
            font-weight: 600;
            color: \(c.text);
        }

        /* ── Horizontal Rule ─────────────────────── */

        hr {
            border: none;
            border-top: 1px solid \(c.border);
            margin-top: 1.5em;
            margin-bottom: 1.5em;
        }

        /* ── Images ──────────────────────────────── */

        img {
            max-width: 100%;
        }

        /* ── Emphasis ────────────────────────────── */

        strong { font-weight: 700; }
        del { color: \(c.textTertiary); }
        """
    }
}
