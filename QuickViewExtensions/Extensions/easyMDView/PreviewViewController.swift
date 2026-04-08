import Cocoa
import Quartz

class PreviewViewController: NSViewController, QLPreviewingController {

    private var scrollView: NSScrollView!
    private var textView: NSTextView!

    override func loadView() {
        // Container
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 400))
        container.autoresizingMask = [.width, .height]

        // Scroll view
        scrollView = NSScrollView(frame: container.bounds)
        scrollView.autoresizingMask = [.width, .height]
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = true
        container.addSubview(scrollView)

        // Text view
        let contentSize = scrollView.contentSize
        let textContainer = NSTextContainer(containerSize: NSSize(
            width: contentSize.width,
            height: .greatestFiniteMagnitude
        ))
        textContainer.widthTracksTextView = true

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)

        textView = NSTextView(frame: NSRect(origin: .zero, size: contentSize), textContainer: textContainer)
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.autoresizingMask = [.width]
        textView.isRichText = true
        textView.textContainerInset = NSSize(width: 24, height: 24)
        textView.drawsBackground = true
        textView.linkTextAttributes = [
            .foregroundColor: NSColor.linkColor,
            .cursor: NSCursor.pointingHand
        ]

        scrollView.documentView = textView
        self.view = container
    }

    // MARK: - QLPreviewingController

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        // Detect appearance
        let isDark = isDarkMode()
        applyAppearance(isDark: isDark)

        do {
            let data = try Data(contentsOf: url, options: [.uncached])
            let encoding = data.stringEncoding ?? .utf8

            guard let markdownString = String(data: data, encoding: encoding) else {
                handler(NSError(domain: "easyMDView", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Cannot decode file"]))
                return
            }

            let html = MarkdownParser.toHTML(markdownString)
            let fullHTML = HTMLTemplate.wrap(html, darkMode: isDark)

            guard let htmlData = fullHTML.data(using: .utf8),
                  let attributedString = NSAttributedString(
                      html: htmlData,
                      baseURL: url.deletingLastPathComponent(),
                      documentAttributes: nil
                  ) else {
                textView.string = markdownString
                self.view.display()
                handler(nil)
                return
            }

            if let ts = textView.textStorage {
                ts.beginEditing()
                ts.setAttributedString(attributedString)
                ts.endEditing()
            }

            self.view.display()
            handler(nil)
        } catch {
            handler(error)
        }
    }

    // MARK: - Appearance

    private func isDarkMode() -> Bool {
        let appearance = NSApp?.effectiveAppearance
            ?? NSAppearance.currentDrawing()
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    private func applyAppearance(isDark: Bool) {
        let bgColor = isDark ? NSColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1) // #1e1e1e
                             : NSColor.white
        textView.backgroundColor = bgColor
        scrollView.backgroundColor = bgColor
        scrollView.scrollerKnobStyle = isDark ? .light : .dark
        view.appearance = isDark ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua)
    }
}

// MARK: - Data encoding detection

extension Data {
    /// Attempt to detect string encoding from BOM or content.
    var stringEncoding: String.Encoding? {
        var nsString: NSString?
        guard !isEmpty else { return .utf8 }
        NSString.stringEncoding(
            for: self,
            encodingOptions: nil,
            convertedString: &nsString,
            usedLossyConversion: nil
        )
        // If NSString could detect it, use that; otherwise nil to let caller decide
        if nsString != nil {
            return .utf8
        }
        return nil
    }
}
