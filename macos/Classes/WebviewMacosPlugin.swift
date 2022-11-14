import Cocoa
import FlutterMacOS
import WebKit

public class WebviewMacosPlugin: NSObject, FlutterPlugin, WKNavigationDelegate, NSWindowDelegate {
    
    var webViewController: WebViewController?
    var windowController: NSWindowController?
    var methodChannel: FlutterMethodChannel!
    var windowIsOpen: Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "webview_macos_plugin", binaryMessenger: registrar.messenger)
        let instance = WebviewMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func setupWebViewController(reset: Bool = false){
        if webViewController == nil || reset {
            if reset {
                if let wkController = webViewController {
                    wkController.dispose()
                }
                if let windowController = windowController {
                    windowController.close()
                }
            }
            webViewController = WebViewController()
        }
    }
    
    public func setupMethodChannel(){
        if methodChannel == nil {
            guard let context: FlutterViewController = NSApplication.mainFlutterController as? FlutterViewController else { return }
            methodChannel = FlutterMethodChannel(name: "webview_macos_plugin", binaryMessenger: context.engine.binaryMessenger)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        setupWebViewController()
        setupMethodChannel()
        switch call.method {
        case "showWebView":
            guard let context = NSApplication.mainFlutterController else {
                result(["result": false, "error": FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find main view controller", details: nil)])
                return
            }
            guard let webViewController = webViewController else {
                result(["result": false, "error": FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find web view controller", details: nil)])
                return
            }
            var title: String = "WebView"
            var windowSize: CGSize = CGSize.defaultWindowSize
            if let arguments = call.arguments as? Dictionary<String, Any> {
                if let resetPreviousInstance: Bool = arguments["resetPreviousInstance"] as? Bool, resetPreviousInstance {
                    setupWebViewController(reset: true)
                }
                
                if let argTitle = arguments["windowTitle"] as? String {
                    title = argTitle
                }
                if let argWidth = arguments["windowWidth"] as? Double {
                    windowSize.width = argWidth
                }
                if let argHeight = arguments["windowHeight"] as? Double {
                    windowSize.height = argHeight
                }
                if let argNavStart = arguments["onNavigationStart"] as? Bool, argNavStart {
                    webViewController.onNavigationStart = { url, innerHTML, error in
                        if let methodChannel = self.methodChannel {
                            var fError: FlutterError? = nil
                            if let error = error {
                                fError = FlutterError(code: "ON_START_ERROR", message: error.localizedDescription, details: nil)
                            }
                            methodChannel.invokeMethod("onNavigationStart", arguments: ["url": url?.absoluteString ?? "", "innerHTML":  innerHTML, "error": fError?.toMap])
                        }
                    }
                }
                
                if let argNavCommit = arguments["onNavigationCommit"] as? Bool, argNavCommit {
                    webViewController.onNavigationCommit = { url, innerHTML, error in
                        if let methodChannel = self.methodChannel {
                            var fError: FlutterError? = nil
                            if let error = error {
                                fError = FlutterError(code: "ON_COMMIT_ERROR", message: error.localizedDescription, details: nil)
                            }
                            methodChannel.invokeMethod("onNavigationCommit", arguments: ["url": url?.absoluteString ?? "", "innerHTML": innerHTML, "error": fError?.toMap])
                        }
                    }
                }
                
                if let argNavFinished = arguments["onNavigationFinished"] as? Bool, argNavFinished {
                    webViewController.onNavigationCommit = { url, innerHTML, error in
                        if let methodChannel = self.methodChannel {
                            var fError: FlutterError? = nil
                            if let error = error {
                                fError = FlutterError(code: "ON_DID_FINISH_ERROR", message: error.localizedDescription, details: nil)
                            }
                            methodChannel.invokeMethod("onNavigationFinished", arguments: ["url": url?.absoluteString ?? "", "innerHTML": innerHTML, "error": fError?.toMap])
                        }
                    }
                }
                
                if let argNavError = arguments["onNavigationError"] as? Bool, argNavError {
                    webViewController.onNavigationError = { url, innerHTML, error in
                        if let methodChannel = self.methodChannel {
                            var fError: FlutterError? = nil
                            if let error = error {
                                fError = FlutterError(code: "ON_NAVIGATION_ERROR", message: error.localizedDescription, details: nil)
                            }
                            methodChannel.invokeMethod("onNavigationError", arguments: ["url": url?.absoluteString ?? "", "innerHTML": innerHTML, "error": fError?.toMap])
                        }
                    }
                }
                
                if let argOnWebViewOpen = arguments["onWebViewOpened"] as? Bool, argOnWebViewOpen {
                    webViewController.onWebViewOpened = {
                        self.windowIsOpen = true
                        if let methodChannel = self.methodChannel {
                            methodChannel.invokeMethod("onWebViewOpened", arguments: nil)
                        }
                    }
                }
                
                if let initialURL = arguments["url"] as? String, let url = URL(string: initialURL) {
                    webViewController.initialURL = url
                    _ = webViewController.loadURL(url: url)
                }
            }
            
            let newWindowController: NSWindowController = context.presentInNewWindow(viewController: webViewController, windowTitle: title, windowSize: windowSize)
            newWindowController.window?.delegate = self
            windowController = newWindowController
            result(["result" : true, "error": nil])
        case "loadURL":
            guard let webViewController = webViewController, let urlString = call.arguments as? String, let url = URL(string: urlString) else {
                result(FlutterError(code: "INVALID_URL", message: "URL is invalid", details: nil))
                return
            }
            result(webViewController.loadURL(url: url))
        case "loadHTMLString":
            guard let webViewController = webViewController, let htmlString = call.arguments as? String, !htmlString.isEmpty else {
                result(FlutterError(code: "INVALID_HTML", message: "HTML is invalid", details: nil))
                return
            }
            result(webViewController.loadHTMLString(htmlString))
        case "evaluateJavaScript":
            guard let webViewController = webViewController, let jsString = call.arguments as? String, !jsString.isEmpty else {
                result(FlutterError(code: "INVALID_JAVASCRIPT", message: "JavaScript code is invalid", details: nil))
                return
            }
            webViewController.evaluateJavaScript(jsString) {
                if let err = $1 as? WebViewError {
                    result(FlutterError(code: err.code, message: err.message, details: nil))
                } else {
                    result($0)
                }
            }
        case "isShowing":
            result(self.windowIsOpen)
        case "dismissWebView":
            guard let context = windowController else {
                result(FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find webview window controller", details: nil))
                return
            }
            self.webViewController = nil
            context.close()
            self.windowController = nil
            self.windowIsOpen = false
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func windowWillClose(_ notification: Notification) {
        self.windowIsOpen = false
        if let methodChannel = self.methodChannel {
            methodChannel.invokeMethod("onWebViewClosed", arguments: nil)
        }
    }
    
}
