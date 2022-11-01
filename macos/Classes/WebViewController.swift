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
    
    var onNavigationStart: ((URL?, String, Error?) -> Void)?
    var onNavigationCommit: ((URL?, String, Error?) -> Void)?
    var didFinishNavigation: ((URL?, String, Error?) -> Void)?
    var onNavigationError: ((URL?, String, Error?) -> Void)?
    var allowRedirect: Bool = true
    
    var defaultTimeoutInterval: Double = 300
    var defaultCachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(initialURL: URL? = nil, defaultTimeoutInterval: Double = 300, defaultCachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData) {
        self.init(nibName: nil, bundle: nil)
        if let initialURL = initialURL {
            self.initialURL = initialURL
        }
        self.defaultTimeoutInterval = defaultTimeoutInterval
        self.defaultCachePolicy = defaultCachePolicy
        
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
    
    // Request start
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        webView.getInnerHTML { innerHTML, error in
            if let onNavigationStart = self.onNavigationStart {
                onNavigationStart(webView.url, innerHTML, error)
            }
        }
    }
    
    // Request commit
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        webView.getInnerHTML { innerHTML, error in
            if let onNavigationCommit = self.onNavigationCommit {
                onNavigationCommit(webView.url, innerHTML, error)
            }
        }
    }
    
    // Finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        webView.getInnerHTML { innerHTML, error in
            if let didFinishNavigation = self.didFinishNavigation {
                didFinishNavigation(webView.url, innerHTML, error)
            }
        }
    }
    
    // Loading Error
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        if let onNavigationError = self.onNavigationError {
            webView.getInnerHTML { innerHTML, error in
                onNavigationError(webView.url, innerHTML, error)
            }
        }
    }
    
    // Redirect Policy
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if allowRedirect, navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {return}
            webView.load(URLRequest(url: url))
        }
        decisionHandler(allowRedirect ? .allow : .cancel)
    }
    
    func dispose(){
        self.view.disposeOfEverySubview()
    }
}

struct WebViewError: Error {
    var code: String!
    var message: String!
}
