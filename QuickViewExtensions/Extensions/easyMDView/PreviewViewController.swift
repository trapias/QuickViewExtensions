import Cocoa
import Quartz
import WebKit

class PreviewViewController: NSViewController, QLPreviewingController {

    private var webView: WKWebView!

    override func loadView() {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(false, forKey: "javaScriptCanOpenWindowsAutomatically")

        webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 600, height: 400), configuration: config)
        webView.navigationDelegate = self
        self.view = webView
    }

    // MARK: - QLPreviewingController

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        let fullHTML: String
        do {
            let markdown = try String(contentsOf: url, encoding: .utf8)
            let html = MarkdownParser.toHTML(markdown)
            fullHTML = HTMLTemplate.wrap(html)
        } catch {
            if let data = try? Data(contentsOf: url),
               let decoded = String(data: data, encoding: .isoLatin1) {
                let html = MarkdownParser.toHTML(decoded)
                fullHTML = HTMLTemplate.wrap(html)
            } else {
                handler(error)
                return
            }
        }

        webView.loadHTMLString(fullHTML, baseURL: url.deletingLastPathComponent())
        handler(nil)
    }
}

// MARK: - WKNavigationDelegate

extension PreviewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                NSWorkspace.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
