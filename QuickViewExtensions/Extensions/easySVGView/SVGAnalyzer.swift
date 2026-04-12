import Foundation

/// Extracts metadata from SVG content by parsing XML attributes.
enum SVGAnalyzer {

    struct SVGInfo {
        var width: String?
        var height: String?
        var viewBox: String?
        var elementCount: Int = 0
        var hasText: Bool = false
        var hasGradients: Bool = false
        var hasFilters: Bool = false
        var hasAnimations: Bool = false
        var fileSize: String = ""
    }

    static func analyze(_ svg: String, fileSize: Int) -> SVGInfo {
        var info = SVGInfo()

        info.fileSize = formatFileSize(fileSize)

        // Extract <svg> root attributes
        if let svgTagRange = svg.range(of: "<svg[^>]*>", options: .regularExpression) {
            let svgTag = String(svg[svgTagRange])

            info.width = extractAttribute("width", from: svgTag)
            info.height = extractAttribute("height", from: svgTag)
            info.viewBox = extractAttribute("viewBox", from: svgTag)
        }

        // Count elements
        let elementPattern = "<(?!/)(?!\\?)(\\w+)"
        if let regex = try? NSRegularExpression(pattern: elementPattern) {
            let range = NSRange(svg.startIndex..., in: svg)
            info.elementCount = regex.numberOfMatches(in: svg, range: range)
        }

        // Detect features
        info.hasText = svg.contains("<text") || svg.contains("<tspan")
        info.hasGradients = svg.contains("Gradient") || svg.contains("gradient")
        info.hasFilters = svg.contains("<filter")
        info.hasAnimations = svg.contains("<animate") || svg.contains("<animateTransform")

        return info
    }

    private static func extractAttribute(_ name: String, from tag: String) -> String? {
        let pattern = "\(name)\\s*=\\s*\"([^\"]*)\""
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: tag, range: NSRange(tag.startIndex..., in: tag)),
              let range = Range(match.range(at: 1), in: tag) else {
            return nil
        }
        return String(tag[range])
    }

    private static func formatFileSize(_ bytes: Int) -> String {
        if bytes < 1024 { return "\(bytes) B" }
        if bytes < 1024 * 1024 { return String(format: "%.1f KB", Double(bytes) / 1024) }
        return String(format: "%.1f MB", Double(bytes) / (1024 * 1024))
    }
}
