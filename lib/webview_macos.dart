import 'webview_macos_platform_interface.dart';

class WebviewMacos {
  Future<void> showWebView(String initialURL) {
    return WebviewMacosPlatform.instance.showWebView(initialURL);
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

  Future<void> dismissWebView() {
    return WebviewMacosPlatform.instance.dismissWebView();
  }
}
