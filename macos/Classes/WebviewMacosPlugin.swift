import Cocoa
import FlutterMacOS
import WebKit

public class WebviewMacosPlugin: NSObject, FlutterPlugin, WKNavigationDelegate {
    
    var webViewController: WebViewController?
    var windowController: NSWindowController?
    var methodChannel: FlutterMethodChannel!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "webview_macos_plugin", binaryMessenger: registrar.messenger)
        let instance = WebviewMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func setupMethodChannel(){
        if methodChannel == nil {
            guard let context: FlutterViewController = NSApplication.shared.keyWindow?.contentViewController as? FlutterViewController else { return }
            methodChannel = FlutterMethodChannel(name: "webview_macos_plugin", binaryMessenger: context.engine.binaryMessenger)
        }
    }
    
    public func setupWebViewController(){
        if webViewController == nil {
            webViewController = WebViewController()
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        setupWebViewController()
        setupMethodChannel()
        switch call.method {
        case "showWebView":
            guard let webViewController = webViewController, let context = NSApplication.shared.keyWindow?.contentViewController else {
                result(FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find view controller", details: nil))
                return
            }
            if let initialURL = call.arguments as? String, let url = URL(string: initialURL) {
                webViewController.initialURL = url
                _ = webViewController.loadURL(url: url)
            }
            windowController = context.presentInNewWindow(viewController: webViewController, title: "WebView")
            result(true)
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
        case "didFinish":
            guard let webViewController = webViewController else {
                result(FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find view controller", details: nil))
                return
            }
            webViewController.didFinishNavigation = { url, innerHTML, error in
                if let methodChannel = self.methodChannel {
                    if let error = error {
                        methodChannel.invokeMethod("didFinish", arguments: FlutterError(code: "DID_FINISH_ERROR", message: error.localizedDescription, details: nil))
                    } else {
                        methodChannel.invokeMethod("didFinish", arguments: [url?.absoluteString ?? "", innerHTML])
                    }
                }
            }
            result(true)
        case "dismissWebView":
            guard let context = windowController else {
                result(FlutterError(code: "INVALID_VIEW_CONTROLLER", message: "Could not find view controller", details: nil))
                return
            }
            self.webViewController = nil
            context.close()
            self.windowController = nil
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
}
