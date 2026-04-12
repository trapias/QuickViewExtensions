import Foundation

/// Renders log files with color-coded severity levels and summary badges.
enum LogRenderer {

    private static let maxLines = 1000

    enum Level: String, CaseIterable {
        case error = "ERROR"
        case warn = "WARN"
        case info = "INFO"
        case debug = "DEBUG"
        case trace = "TRACE"

        var cssClass: String { rawValue.lowercased() }
    }

    static func render(_ content: String) -> String {
        let allLines = content.components(separatedBy: "\n")
        let truncated = allLines.count > maxLines
        let lines = truncated ? Array(allLines.suffix(maxLines)) : allLines

        var counts: [Level: Int] = [:]
        Level.allCases.forEach { counts[$0] = 0 }

        var html = ""
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                html += "<div class=\"log-line\">&nbsp;</div>"
                continue
            }

            let level = detectLevel(trimmed)
            if let level = level {
                counts[level, default: 0] += 1
            }
            let cls = level?.cssClass ?? "log-plain"
            html += "<div class=\"log-line \(cls)\">\(escapeHTML(trimmed))</div>"
        }

        // Info bar
        var info = "<div class=\"log-info\">"
        info += "<span class=\"log-badge\">\(allLines.count) lines</span>"
        if truncated {
            info += "<span class=\"log-badge log-trunc\">Showing last \(maxLines)</span>"
        }
        if let e = counts[.error], e > 0 {
            info += "<span class=\"log-badge log-b-error\">\(e) errors</span>"
        }
        if let w = counts[.warn], w > 0 {
            info += "<span class=\"log-badge log-b-warn\">\(w) warnings</span>"
        }
        info += "</div>"

        return info + "<div class=\"log-content\">" + html + "</div>"
    }

    private static func detectLevel(_ line: String) -> Level? {
        let upper = line.uppercased()
        // Check common log patterns: [ERROR], ERROR, level=error
        if upper.contains("ERROR") || upper.contains("FATAL") || upper.contains("CRITICAL") { return .error }
        if upper.contains("WARN") { return .warn }
        if upper.contains("INFO") { return .info }
        if upper.contains("DEBUG") { return .debug }
        if upper.contains("TRACE") || upper.contains("VERBOSE") { return .trace }
        return nil
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
