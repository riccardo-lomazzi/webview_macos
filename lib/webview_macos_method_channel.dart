import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:webview_macos/exceptions.dart';

import 'webview_macos_platform_interface.dart';

/// An implementation of [WebViewMacOSPlatform] that uses method channels.
class MethodChannelWebViewMacOS extends WebViewMacOSPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('webview_macos_plugin');

  bool methodCallHandlerHasBeenSet = false;
  Map<String, Function?> savedCallbacks = {};

  @override
  Future<bool> showWebView({
    String? url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    double? windowWidth,
    double? windowHeight,
    Function(String, String, WebViewMacOSException?)? onNavigationStart,
    Function(String, String, WebViewMacOSException?)? onNavigationCommit,
    Function(String, String, WebViewMacOSException?)? onNavigationError,
    Function(String, String, WebViewMacOSException?)? onNavigationFinished,
    Function()? onWebViewOpened,
    Function()? onWebViewClosed,
  }) async {
    try {
      savedCallbacks.addAll({
        "onNavigationStart": onNavigationStart,
        "onNavigationCommit": onNavigationCommit,
        "onNavigationError": onNavigationError,
        "onNavigationFinished": onNavigationFinished,
        "onWebViewOpened": onWebViewOpened,
        "onWebViewClosed": onWebViewClosed,
      });
      if (!methodCallHandlerHasBeenSet) {
        methodChannel.setMethodCallHandler(this._genericMethodHandler);
        methodCallHandlerHasBeenSet = true;
      }
      Map<String, dynamic>? showWebViewResponse =
          await methodChannel.invokeMapMethod<String, dynamic>("showWebView", {
        "url": url,
        "windowTitle": windowTitle,
        "resetPreviousInstance": resetPreviousInstance,
        "onNavigationStart": onNavigationStart != null,
        "onNavigationCommit": onNavigationCommit != null,
        "onNavigationError": onNavigationError != null,
        "onNavigationFinished": onNavigationFinished != null,
        "onWebViewOpened": onWebViewOpened != null,
        "onWebViewClosed": onWebViewClosed != null,
      });
      if (showWebViewResponse == null) {
        throw Exception("Failed to start WebView");
      }
      if (showWebViewResponse["error"] != null) {
        throw showWebViewResponse["error"];
      }
      if (showWebViewResponse["result"] == true) {
        return true;
      } else {
        throw Exception("Failed to start WebView");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<bool> loadURL(String url) async {
    final result = await methodChannel.invokeMethod("loadURL", url);
    return result ?? false;
  }

  @override
  Future<bool> loadHTMLString(String htmlString) async {
    final result =
        await methodChannel.invokeMethod("loadHTMLString", htmlString);
    return result ?? false;
  }

  @override
  Future<String?> evaluateJavaScript(String jsString) async {
    final result =
        await methodChannel.invokeMethod("evaluateJavaScript", jsString);
    return result;
  }

  @override
  Future<bool> isShowing() async {
    return await methodChannel.invokeMethod("isShowing") ?? false;
  }

  @override
  Future<bool> clearDataStore() async {
    return await methodChannel.invokeMethod("clearDataStore") ?? false;
  }

  @override
  Future<void> dismissWebView() async {
    final _ = await methodChannel.invokeMethod('dismissWebView');
    return;
  }

  Future<void> _genericMethodHandler(MethodCall call) async {
    String url = "";
    String html = "";
    WebViewMacOSException? error;
    if (call.method.startsWith("onNavigation")) {
      url = call.arguments["url"] ?? "";
      html = call.arguments["innerHTML"] ?? "";
      error = call.arguments["error"] != null
          ? WebViewMacOSException.fromMap(call.arguments["error"])
          : null;
      if (savedCallbacks[call.method] != null) {
        savedCallbacks[call.method]!(url, html, error);
      }
    } else if (call.method == "onWebViewClosed" &&
        savedCallbacks["onWebViewClosed"] != null) {
      savedCallbacks["onWebViewClosed"]!();
    } else if (call.method == "onWebViewOpened" &&
        savedCallbacks["onWebViewOpened"] != null) {
      savedCallbacks["onWebViewOpened"]!();
    }
  }
}
