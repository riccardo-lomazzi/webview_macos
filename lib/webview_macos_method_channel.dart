import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview_macos_platform_interface.dart';

/// An implementation of [WebviewMacosPlatform] that uses method channels.
class MethodChannelWebviewMacos extends WebviewMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('webview_macos_plugin');

  bool methodCallHandlerHasBeenSet = false;
  Map<String, dynamic Function(String, String, FlutterError?)?> savedCallbacks =
      {};

  @override
  Future<bool> showWebView({
    required String url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    double? windowWidth,
    double? windowHeight,
    Function(String, String, FlutterError?)? onNavigationStart,
    Function(String, String, FlutterError?)? onNavigationCommit,
    Function(String, String, FlutterError?)? onNavigationError,
    Function(String, String, FlutterError?)? onNavigationFinished,
  }) async {
    try {
      savedCallbacks.addAll({
        "onNavigationStart": onNavigationStart,
        "onNavigationCommit": onNavigationCommit,
        "onNavigationError": onNavigationError,
        "onNavigationFinished": onNavigationFinished,
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
  Future<void> dismissWebView() async {
    final _ = await methodChannel.invokeMethod('dismissWebView');
    return;
  }

  Future<void> _genericMethodHandler(MethodCall call) async {
    String url = "";
    String html = "";
    FlutterError? error;
    if (call.method.startsWith("onNavigation")) {
      url = call.arguments["url"] ?? "";
      html = call.arguments["innerHTML"] ?? "";
      error = call.arguments["error"];
      if (savedCallbacks[call.method] != null) {
        savedCallbacks[call.method]!(url, html, error);
      }
    }
  }
}
