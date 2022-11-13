import 'package:flutter/material.dart';

import 'webview_macos_platform_interface.dart';

class WebviewMacos {
  static Future<bool> showWebView({
    required String url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    Function(String, String, FlutterError?)? onNavigationStart,
    Function(String, String, FlutterError?)? onNavigationCommit,
    Function(String, String, FlutterError?)? onNavigationError,
    Function(String, String, FlutterError?)? onNavigationFinished,
  }) async {
    return WebviewMacosPlatform.instance.showWebView(
      url: url,
      resetPreviousInstance: resetPreviousInstance,
      windowTitle: windowTitle,
      onNavigationStart: onNavigationStart,
      onNavigationCommit: onNavigationCommit,
      onNavigationError: onNavigationError,
      onNavigationFinished: onNavigationFinished,
    );
  }

  static Future<bool> loadURL(String url) {
    return WebviewMacosPlatform.instance.loadURL(url);
  }

  static Future<bool> loadHTMLString(String htmlString) {
    return WebviewMacosPlatform.instance.loadHTMLString(htmlString);
  }

  static Future<String?> evaluateJavaScript(String jsString) {
    return WebviewMacosPlatform.instance.evaluateJavaScript(jsString);
  }

  static Future<void> dismissWebView() {
    return WebviewMacosPlatform.instance.dismissWebView();
  }
}
