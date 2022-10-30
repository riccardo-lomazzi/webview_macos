//
//  WebViewController.swift
//  new_webview_macos
//
//  Created by riccardo on 30/10/22.
//

import Foundation
import WebKit

class WebViewController: NSViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var initialURL: URL!
    var didFinishNavigation: ((URL?, String, Error?) -> Void)?
    
    let defaultTimeoutInterval: Double = 300
    let defaultCachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(initialURL: URL? = nil) {
        self.init(nibName: nil, bundle: nil)
        if let initialURL = initialURL {
            self.initialURL = initialURL
        }
    }
    
    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 1000, height: 600))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wkWbViewConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: view.frame, configuration: wkWbViewConfig)
        self.webView.navigationDelegate = self
        if let initialURL = self.initialURL {
            self.webView.load(URLRequest(url: initialURL, cachePolicy: defaultCachePolicy, timeoutInterval: defaultTimeoutInterval))
        }
        self.view.addSubview(self.webView)
    }
    
    func loadURL(url: URL) -> Bool {
        guard let webView = self.webView else { return false }
        let urlRequest = URLRequest(url: url, cachePolicy: defaultCachePolicy, timeoutInterval: defaultTimeoutInterval)
        webView.load(urlRequest)
        return true
    }
    
    func loadHTMLString(_ htmlString: String) -> Bool {
        guard let webView = self.webView else { return false }
        return webView.loadHTMLString(htmlString, baseURL: nil) != nil
    }
    
    func evaluateJavaScript(_ jsString: String, completionHandler: @escaping (String, Error?) -> Void) {
        guard let webView = self.webView else {
            completionHandler("ERROR", WebViewError(code: "INVALID_WEBVIEW", message: "Webview doesn't exist"))
            return
        }
        webView.evaluateJavaScript(jsString) { result, error in
            guard let res = result as? String else {
                if let err = error {
                    completionHandler("ERROR", err)
                } else {
                    completionHandler("ERROR", WebViewError(code: "INVALID_RESULT", message: "Result is not a string"))
                }
                return
            }
            if let err = error {
                completionHandler("ERROR", err)
            } else {
                completionHandler(res, nil)
            }
        }
    }
    
    // invio richiesta al server
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
    }
    
    // ricevuto contenuti da server
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
    }
    
    // caricamento contenuti da server terminato
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
            var unwrappedInnerHTML: String = ""
            if let innHTML = innerHTML as? String {
                unwrappedInnerHTML = innHTML
            }
            if let didFinishNavigation = self.didFinishNavigation {
                didFinishNavigation(webView.url, unwrappedInnerHTML, error)
            }
        }
    }
    
    // errore caricamento
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
    }
    
    // policy per redirect
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {return}
            webView.load(URLRequest(url: url))
        }
        decisionHandler(.allow)
    }
    
    
}

struct WebViewError: Error {
    var code: String!
    var message: String!
}
