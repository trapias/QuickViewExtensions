import Foundation

/// Converts a JSON string into an interactive HTML tree with syntax highlighting
/// and collapsible nodes using native <details>/<summary> elements.
enum JSONRenderer {

    /// Renders a JSON string as an HTML tree.
    /// Returns an error panel if the JSON is invalid.
    static func render(_ jsonString: String) -> String {
        let trimmed = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return errorHTML("Empty file")
        }

        do {
            let object = try JSONSerialization.jsonObject(with: Data(trimmed.utf8), options: [.fragmentsAllowed])
            var html = "<div class=\"json-tree\">"
            html += renderValue(object, depth: 0)
            html += "</div>"
            return html
        } catch {
            return errorHTML("Invalid JSON: \(escapeHTML(error.localizedDescription))")
        }
    }

    // MARK: - Recursive rendering

    private static func renderValue(_ value: Any, depth: Int) -> String {
        switch value {
        case let dict as [String: Any]:
            return renderObject(dict, depth: depth)
        case let array as [Any]:
            return renderArray(array, depth: depth)
        case let string as String:
            return "<span class=\"json-string\">\"\(escapeHTML(string))\"</span>"
        case let number as NSNumber:
            if number === kCFBooleanTrue {
                return "<span class=\"json-bool\">true</span>"
            } else if number === kCFBooleanFalse {
                return "<span class=\"json-bool\">false</span>"
            } else {
                return "<span class=\"json-number\">\(number)</span>"
            }
        case is NSNull:
            return "<span class=\"json-null\">null</span>"
        default:
            return "<span class=\"json-string\">\"\(escapeHTML(String(describing: value)))\"</span>"
        }
    }

    private static func renderObject(_ dict: [String: Any], depth: Int) -> String {
        if dict.isEmpty {
            return "<span class=\"json-brace\">{}</span>"
        }

        let sortedKeys = dict.keys.sorted()
        let count = dict.count
        let label = count == 1 ? "1 key" : "\(count) keys"

        var html = "<details\(depth < 2 ? " open" : "")>"
        html += "<summary>"
        html += "<span class=\"json-brace\">{</span>"
        html += " <span class=\"json-count\">\(label)</span>"
        html += "</summary>"
        html += "<div class=\"json-indent\">"

        for (i, key) in sortedKeys.enumerated() {
            let val = dict[key]!
            html += "<div class=\"json-entry\">"
            html += "<span class=\"json-key\">\"\(escapeHTML(key))\"</span>"
            html += "<span class=\"json-colon\">: </span>"
            html += renderValue(val, depth: depth + 1)
            if i < count - 1 {
                html += "<span class=\"json-comma\">,</span>"
            }
            html += "</div>"
        }

        html += "</div>"
        html += "<span class=\"json-brace\">}</span>"
        html += "</details>"
        return html
    }

    private static func renderArray(_ array: [Any], depth: Int) -> String {
        if array.isEmpty {
            return "<span class=\"json-bracket\">[]</span>"
        }

        let count = array.count
        let label = count == 1 ? "1 item" : "\(count) items"

        var html = "<details\(depth < 2 ? " open" : "")>"
        html += "<summary>"
        html += "<span class=\"json-bracket\">[</span>"
        html += " <span class=\"json-count\">\(label)</span>"
        html += "</summary>"
        html += "<div class=\"json-indent\">"

        for (i, item) in array.enumerated() {
            html += "<div class=\"json-entry\">"
            html += "<span class=\"json-index\">\(i)</span>"
            html += "<span class=\"json-colon\">: </span>"
            html += renderValue(item, depth: depth + 1)
            if i < count - 1 {
                html += "<span class=\"json-comma\">,</span>"
            }
            html += "</div>"
        }

        html += "</div>"
        html += "<span class=\"json-bracket\">]</span>"
        html += "</details>"
        return html
    }

    // MARK: - Helpers

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func errorHTML(_ message: String) -> String {
        """
        <div class="json-error">
            <span class="json-error-icon">&#9888;</span>
            <span class="json-error-text">\(message)</span>
        </div>
        """
    }
}
