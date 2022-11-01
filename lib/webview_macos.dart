import 'package:flutter/material.dart';

import 'webview_macos_platform_interface.dart';

class WebviewMacos {
  Future<void> showWebView(String initialURL, [bool reset = true]) {
    return WebviewMacosPlatform.instance.showWebView(initialURL, reset);
  }

  static Future<void> showWebViewWithArgs({
    required String url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    Function(String, String, FlutterError?)? onNavigationStart,
    Function(String, String, FlutterError?)? onNavigationCommit,
    Function(String, String, FlutterError?)? onNavigationError,
    Function(String, String, FlutterError?)? onNavigationFinished,
  }) async {
    return WebviewMacosPlatform.instance.showWebViewWithArgs(
      url: url,
      resetPreviousInstance: resetPreviousInstance,
      windowTitle: windowTitle,
      onNavigationStart: onNavigationStart,
      onNavigationCommit: onNavigationCommit,
      onNavigationError: onNavigationError,
      onNavigationFinished: onNavigationFinished,
    );
  }

  static Future<void> loadURL(String url) {
    return WebviewMacosPlatform.instance.loadURL(url);
  }

  Future<void> loadHTMLString(String htmlString) {
    return WebviewMacosPlatform.instance.loadHTMLString(htmlString);
  }

  Future<String?> evaluateJavaScript(String jsString) {
    return WebviewMacosPlatform.instance.evaluateJavaScript(jsString);
  }

  Future<void> didFinish(Function(String, String, FlutterError?) didFinish) {
    return WebviewMacosPlatform.instance.didFinish(didFinish);
  }

  Future<void> dismissWebView() {
    return WebviewMacosPlatform.instance.dismissWebView();
  }
}
