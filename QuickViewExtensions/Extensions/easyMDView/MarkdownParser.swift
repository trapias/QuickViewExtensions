import Foundation
import Markdown

/// Converts Markdown text to HTML using Apple's swift-markdown library.
enum MarkdownParser {

    /// Parse a Markdown string and return a complete HTML fragment.
    static func toHTML(_ markdown: String) -> String {
        let document = Document(parsing: markdown)
        var converter = HTMLConverter()
        return converter.visit(document)
    }
}

// MARK: - HTML Markup Visitor

/// Walks the Markdown AST and produces HTML output.
private struct HTMLConverter: MarkupVisitor {
    typealias Result = String

    /// Track whether we've emitted any block yet (to add spacers before headings)
    private var isFirstBlock = true

    // MARK: - Document

    mutating func defaultVisit(_ markup: any Markup) -> String {
        markup.children.map { visit($0) }.joined()
    }

    mutating func visitDocument(_ document: Document) -> String {
        isFirstBlock = true
        return document.children.map { visit($0) }.joined(separator: "\n")
    }

    // MARK: - Block Elements

    mutating func visitHeading(_ heading: Heading) -> String {
        let level = heading.level
        let content = heading.children.map { visit($0) }.joined()
        let id = content
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "[^a-z0-9\\-]", with: "", options: .regularExpression)

        // Add vertical space before headings (NSAttributedString ignores CSS margins)
        var spacer = ""
        if !isFirstBlock {
            let spacePx = level <= 2 ? 18 : 12
            spacer = "<p style=\"font-size:\(spacePx)px; line-height:\(spacePx)px;\">&nbsp;</p>"
        }
        isFirstBlock = false
        return "\(spacer)<h\(level) id=\"\(id)\">\(content)</h\(level)>"
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> String {
        let content = paragraph.children.map { visit($0) }.joined()
        return "<p>\(content)</p>"
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> String {
        let content = blockQuote.children.map { visit($0) }.joined(separator: "\n")
        return "<blockquote>\(content)</blockquote>"
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> String {
        let escaped = escapeHTML(codeBlock.code)
        let langClass = codeBlock.language.map { " class=\"language-\($0)\"" } ?? ""
        return "<pre><code\(langClass)>\(escaped)</code></pre>"
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> String {
        let items = unorderedList.children.map { visit($0) }.joined(separator: "\n")
        return "<ul>\(items)</ul>"
    }

    mutating func visitOrderedList(_ orderedList: OrderedList) -> String {
        let items = orderedList.children.map { visit($0) }.joined(separator: "\n")
        let start = orderedList.startIndex
        if start != 1 {
            return "<ol start=\"\(start)\">\(items)</ol>"
        }
        return "<ol>\(items)</ol>"
    }

    mutating func visitListItem(_ listItem: ListItem) -> String {
        // Check if this is a task list item
        if let checkbox = listItem.checkbox {
            let checked = checkbox == .checked ? " checked disabled" : " disabled"
            let content = listItem.children.map { visit($0) }.joined()
            return "<li class=\"task-list-item\"><input type=\"checkbox\"\(checked)> \(content)</li>"
        }
        let content = listItem.children.map { visit($0) }.joined()
        return "<li>\(content)</li>"
    }

    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> String {
        "<hr>"
    }

    mutating func visitHTMLBlock(_ html: HTMLBlock) -> String {
        html.rawHTML
    }

    // MARK: - Table

    mutating func visitTable(_ table: Table) -> String {
        let content = table.children.map { visit($0) }.joined(separator: "\n")
        return "<table>\(content)</table>"
    }

    mutating func visitTableHead(_ tableHead: Table.Head) -> String {
        let cells = tableHead.children.map { visit($0) }.joined()
        return "<thead><tr>\(cells)</tr></thead>"
    }

    mutating func visitTableBody(_ tableBody: Table.Body) -> String {
        let rows = tableBody.children.map { visit($0) }.joined(separator: "\n")
        return "<tbody>\(rows)</tbody>"
    }

    mutating func visitTableRow(_ tableRow: Table.Row) -> String {
        let cells = tableRow.children.map { visit($0) }.joined()
        return "<tr>\(cells)</tr>"
    }

    mutating func visitTableCell(_ tableCell: Table.Cell) -> String {
        let content = tableCell.children.map { visit($0) }.joined()
        let tag = tableCell.parent is Table.Head ? "th" : "td"
        return "<\(tag)>\(content)</\(tag)>"
    }

    // MARK: - Inline Elements

    mutating func visitText(_ text: Text) -> String {
        escapeHTML(text.string)
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> String {
        let content = emphasis.children.map { visit($0) }.joined()
        return "<em>\(content)</em>"
    }

    mutating func visitStrong(_ strong: Strong) -> String {
        let content = strong.children.map { visit($0) }.joined()
        return "<strong>\(content)</strong>"
    }

    mutating func visitStrikethrough(_ strikethrough: Strikethrough) -> String {
        let content = strikethrough.children.map { visit($0) }.joined()
        return "<del>\(content)</del>"
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) -> String {
        "<code>\(escapeHTML(inlineCode.code))</code>"
    }

    mutating func visitLink(_ link: Markdown.Link) -> String {
        let content = link.children.map { visit($0) }.joined()
        let href = link.destination ?? "#"
        let title = link.title.map { " title=\"\(escapeHTML($0))\"" } ?? ""
        return "<a href=\"\(escapeHTML(href))\"\(title)>\(content)</a>"
    }

    mutating func visitImage(_ image: Markdown.Image) -> String {
        let alt = image.children.map { visit($0) }.joined()
        let src = image.source ?? ""
        let title = image.title.map { " title=\"\(escapeHTML($0))\"" } ?? ""
        return "<img src=\"\(escapeHTML(src))\" alt=\"\(escapeHTML(alt))\"\(title)>"
    }

    mutating func visitLineBreak(_ lineBreak: LineBreak) -> String {
        "<br>"
    }

    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> String {
        "\n"
    }

    mutating func visitInlineHTML(_ html: InlineHTML) -> String {
        html.rawHTML
    }

    // MARK: - Helpers

    private func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
