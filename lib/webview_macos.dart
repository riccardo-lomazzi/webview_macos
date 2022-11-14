import 'package:flutter/material.dart';
import 'package:webview_macos/exceptions.dart';

import 'webview_macos_platform_interface.dart';

class WebviewMacos {
  static Future<bool> showWebView({
    String? url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    Function(String, String, WebViewMacOSException?)? onNavigationStart,
    Function(String, String, WebViewMacOSException?)? onNavigationCommit,
    Function(String, String, WebViewMacOSException?)? onNavigationError,
    Function(String, String, WebViewMacOSException?)? onNavigationFinished,
    Function()? onWebViewOpened,
    Function()? onWebViewClosed,
    double? windowWidth,
    double? windowHeight,
  }) async {
    return WebviewMacosPlatform.instance.showWebView(
      url: url,
      resetPreviousInstance: resetPreviousInstance,
      windowTitle: windowTitle,
      onNavigationStart: onNavigationStart,
      onNavigationCommit: onNavigationCommit,
      onNavigationError: onNavigationError,
      onNavigationFinished: onNavigationFinished,
      windowHeight: windowHeight,
      windowWidth: windowWidth,
      onWebViewOpened: onWebViewOpened,
      onWebViewClosed: onWebViewClosed,
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

  static Future<bool> isShowing() {
    return WebviewMacosPlatform.instance.isShowing();
  }
}
