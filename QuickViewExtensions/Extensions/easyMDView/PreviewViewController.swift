import Cocoa
import Quartz
import QuickLookUI
import UniformTypeIdentifiers

class PreviewViewController: NSViewController, QLPreviewingController {

    override var nibName: NSNib.Name? {
        return nil
    }

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 400))
    }

    // MARK: - Data-based preview (macOS 12+, used when QLIsDataBasedPreview = true)

    func providePreview(for request: QLFilePreviewRequest, completionHandler handler: @escaping (QLPreviewReply?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: request.fileURL, options: [.uncached])
            let encoding = data.stringEncoding ?? .utf8

            guard let markdownString = String(data: data, encoding: encoding) else {
                handler(nil, NSError(domain: "easyMDView", code: 1,
                                     userInfo: [NSLocalizedDescriptionKey: "Cannot decode file"]))
                return
            }

            let isDark = Self.isDarkMode()
            let html = MarkdownParser.toHTML(markdownString)
            let fullHTML = HTMLTemplate.wrap(html, darkMode: isDark)

            let reply = QLPreviewReply(
                dataOfContentType: UTType.html,
                contentSize: CGSize(width: 800, height: 800)
            ) { (replyToUpdate: QLPreviewReply) in
                replyToUpdate.stringEncoding = .utf8
                return fullHTML.data(using: .utf8)!
            }

            handler(reply, nil)
        } catch {
            handler(nil, error)
        }
    }

    // MARK: - Fallback view-based preview (older macOS)

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        handler(nil)
    }

    // MARK: - Appearance

    private static func isDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}

// MARK: - Data encoding detection

extension Data {
    var stringEncoding: String.Encoding? {
        var nsString: NSString?
        guard !isEmpty else { return .utf8 }
        NSString.stringEncoding(
            for: self,
            encodingOptions: nil,
            convertedString: &nsString,
            usedLossyConversion: nil
        )
        if nsString != nil {
            return .utf8
        }
        return nil
    }
}
