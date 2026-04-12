import Foundation

/// Parses CSV/TSV content and renders it as a styled HTML table
/// with header row, row count, and column count.
enum CSVRenderer {

    /// Maximum number of rows to render in preview (for very large files).
    private static let maxPreviewRows = 500

    static func render(_ content: String, separator: String = ",") -> String {
        let sep: Character = separator == "\t" ? "\t" : ","
        let rows = parseCSV(content, separator: sep)

        guard !rows.isEmpty else {
            return errorHTML("Empty file — no data found")
        }

        let totalRows = rows.count
        let headerRow = rows[0]
        let dataRows = Array(rows.dropFirst())
        let columnCount = headerRow.count
        let truncated = dataRows.count > maxPreviewRows
        let displayRows = truncated ? Array(dataRows.prefix(maxPreviewRows)) : dataRows

        var html = "<div class=\"csv-info\">"
        html += "<span class=\"csv-badge\">\(totalRows - 1) rows</span>"
        html += "<span class=\"csv-badge\">\(columnCount) columns</span>"
        if sep == Character("\t") {
            html += "<span class=\"csv-badge\">TSV</span>"
        }
        if truncated {
            html += "<span class=\"csv-badge csv-warning\">Showing first \(maxPreviewRows) of \(dataRows.count) rows</span>"
        }
        html += "</div>"

        html += "<div class=\"csv-table-wrapper\">"
        html += "<table>"

        // Header
        html += "<thead><tr>"
        html += "<th class=\"csv-row-num\">#</th>"
        for col in headerRow {
            html += "<th>\(escapeHTML(col))</th>"
        }
        html += "</tr></thead>"

        // Body
        html += "<tbody>"
        for (i, row) in displayRows.enumerated() {
            html += "<tr>"
            html += "<td class=\"csv-row-num\">\(i + 1)</td>"
            for j in 0..<columnCount {
                let cell = j < row.count ? row[j] : ""
                let cssClass = cellClass(for: cell)
                html += "<td\(cssClass.isEmpty ? "" : " class=\"\(cssClass)\"")>\(escapeHTML(cell))</td>"
            }
            html += "</tr>"
        }
        html += "</tbody>"

        html += "</table>"
        html += "</div>"

        return html
    }

    // MARK: - CSV Parsing (RFC 4180 compliant)

    private static func parseCSV(_ content: String, separator: Character = ",") -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentField = ""
        var inQuotes = false
        let chars = Array(content)
        var i = 0

        while i < chars.count {
            let c = chars[i]

            if inQuotes {
                if c == "\"" {
                    // Check for escaped quote
                    if i + 1 < chars.count && chars[i + 1] == "\"" {
                        currentField.append("\"")
                        i += 2
                        continue
                    } else {
                        inQuotes = false
                        i += 1
                        continue
                    }
                } else {
                    currentField.append(c)
                }
            } else {
                if c == "\"" {
                    inQuotes = true
                } else if c == separator {
                    currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
                    currentField = ""
                } else if c == "\r" {
                    // Handle \r\n or standalone \r
                    currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
                    currentField = ""
                    if !currentRow.allSatisfy({ $0.isEmpty }) || rows.isEmpty {
                        rows.append(currentRow)
                    }
                    currentRow = []
                    if i + 1 < chars.count && chars[i + 1] == "\n" {
                        i += 1
                    }
                } else if c == "\n" {
                    currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
                    currentField = ""
                    if !currentRow.allSatisfy({ $0.isEmpty }) || rows.isEmpty {
                        rows.append(currentRow)
                    }
                    currentRow = []
                } else {
                    currentField.append(c)
                }
            }

            i += 1
        }

        // Last field/row
        if !currentField.isEmpty || !currentRow.isEmpty {
            currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
            rows.append(currentRow)
        }

        return rows
    }

    // MARK: - Helpers

    private static func cellClass(for value: String) -> String {
        if value.isEmpty { return "csv-empty" }
        if Double(value) != nil { return "csv-number" }
        if value.lowercased() == "true" || value.lowercased() == "false" { return "csv-bool" }
        return ""
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func errorHTML(_ message: String) -> String {
        """
        <div class="csv-error">
            <span class="csv-error-icon">&#9888;</span>
            <span class="csv-error-text">\(message)</span>
        </div>
        """
    }
}
