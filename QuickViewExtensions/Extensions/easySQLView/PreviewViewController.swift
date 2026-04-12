import Cocoa
import Quartz
import QuickLookUI
import UniformTypeIdentifiers

class PreviewViewController: NSViewController, QLPreviewingController {

    override var nibName: NSNib.Name? { return nil }

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 400))
    }

    func providePreview(for request: QLFilePreviewRequest, completionHandler handler: @escaping (QLPreviewReply?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: request.fileURL, options: [.uncached])
            let encoding = data.stringEncoding ?? .utf8

            guard let content = String(data: data, encoding: encoding) else {
                handler(nil, NSError(domain: "easySQLView", code: 1,
                                     userInfo: [NSLocalizedDescriptionKey: "Cannot decode file"]))
                return
            }

            let isDark = Self.isDarkMode()
            let lineCount = content.components(separatedBy: "\n").count
            let html = HTMLTemplate.wrap(content, lineCount: lineCount,
                                          fileSize: data.count, darkMode: isDark)

            let reply = QLPreviewReply(
                dataOfContentType: UTType.html,
                contentSize: CGSize(width: 800, height: 800)
            ) { (replyToUpdate: QLPreviewReply) in
                replyToUpdate.stringEncoding = .utf8
                return html.data(using: .utf8)!
            }
            handler(reply, nil)
        } catch {
            handler(nil, error)
        }
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        handler(nil)
    }

    private static func isDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
}

extension Data {
    var stringEncoding: String.Encoding? {
        var nsString: NSString?
        guard !isEmpty else { return .utf8 }
        NSString.stringEncoding(for: self, encodingOptions: nil, convertedString: &nsString, usedLossyConversion: nil)
        if nsString != nil { return .utf8 }
        return nil
    }
}
