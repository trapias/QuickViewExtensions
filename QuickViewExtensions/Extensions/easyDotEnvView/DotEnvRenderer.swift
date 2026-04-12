import Foundation

/// Renders .env files with key-value highlighting and masked secret values.
enum DotEnvRenderer {

    /// Patterns that suggest a value is a secret.
    private static let secretPatterns = [
        "SECRET", "PASSWORD", "PASSWD", "TOKEN", "KEY", "API_KEY",
        "PRIVATE", "CREDENTIAL", "AUTH", "SIGNING"
    ]

    static func render(_ content: String) -> String {
        let lines = content.components(separatedBy: "\n")
        var varCount = 0
        var emptyCount = 0

        var rows = ""
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Empty line
            if trimmed.isEmpty {
                rows += "<tr class=\"env-empty\"><td colspan=\"3\">&nbsp;</td></tr>"
                continue
            }

            // Comment
            if trimmed.hasPrefix("#") {
                rows += "<tr class=\"env-comment\"><td colspan=\"3\">\(escapeHTML(trimmed))</td></tr>"
                continue
            }

            // Key=Value
            guard let eqIndex = trimmed.firstIndex(of: "=") else {
                rows += "<tr class=\"env-comment\"><td colspan=\"3\">\(escapeHTML(trimmed))</td></tr>"
                continue
            }

            let key = String(trimmed[trimmed.startIndex..<eqIndex]).trimmingCharacters(in: .whitespaces)
            var value = String(trimmed[trimmed.index(after: eqIndex)...]).trimmingCharacters(in: .whitespaces)

            // Remove surrounding quotes
            if (value.hasPrefix("\"") && value.hasSuffix("\"")) ||
               (value.hasPrefix("'") && value.hasSuffix("'")) {
                value = String(value.dropFirst().dropLast())
            }

            varCount += 1
            if value.isEmpty { emptyCount += 1 }

            let isSecret = secretPatterns.contains { key.uppercased().contains($0) }
            let maskedValue = isSecret && !value.isEmpty ? String(repeating: "•", count: min(value.count, 20)) : value
            let valueClass = value.isEmpty ? "env-val-empty" : (isSecret ? "env-val-secret" : "env-val")

            rows += "<tr>"
            rows += "<td class=\"env-key\">\(escapeHTML(key))</td>"
            rows += "<td class=\"env-eq\">=</td>"
            rows += "<td class=\"\(valueClass)\">\(value.isEmpty ? "<em>empty</em>" : escapeHTML(maskedValue))</td>"
            rows += "</tr>"
        }

        var info = "<div class=\"env-info\">"
        info += "<span class=\"env-badge\">\(varCount) variables</span>"
        if emptyCount > 0 {
            info += "<span class=\"env-badge env-warning\">\(emptyCount) empty</span>"
        }
        info += "</div>"

        return info + "<table class=\"env-table\">" + rows + "</table>"
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
}
