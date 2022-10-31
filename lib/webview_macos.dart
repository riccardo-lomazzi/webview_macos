import 'webview_macos_platform_interface.dart';

class WebviewMacos {
  Future<void> showWebView(String initialURL, [bool reset = true]) {
    return WebviewMacosPlatform.instance.showWebView(initialURL, reset);
  }

  Future<void> loadURL(String url) {
    return WebviewMacosPlatform.instance.loadURL(url);
  }

  Future<void> loadHTMLString(String htmlString) {
    return WebviewMacosPlatform.instance.loadHTMLString(htmlString);
  }

  Future<String?> evaluateJavaScript(String jsString) {
    return WebviewMacosPlatform.instance.evaluateJavaScript(jsString);
  }

  Future<void> didFinish(Function(String, String, bool) didFinish) {
    return WebviewMacosPlatform.instance.didFinish(didFinish);
  }

  Future<void> dismissWebView() {
    return WebviewMacosPlatform.instance.dismissWebView();
  }
}
