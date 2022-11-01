import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview_macos_platform_interface.dart';

/// An implementation of [WebviewMacosPlatform] that uses method channels.
class MethodChannelWebviewMacos extends WebviewMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('webview_macos_plugin');

  bool methodCallHandlerHasBeenSet = false;
  Function(String, String, bool)? didFinishCallback;
  Map<String, dynamic Function(String, String, FlutterError?)?> savedCallbacks =
      {};

  @override
  @deprecated
  Future<void> showWebView(String initialURL, [bool reset = true]) async {
    final _ =
        await methodChannel.invokeMethod('showWebView', [initialURL, reset]);
    return;
  }

  @override
  Future<void> showWebViewWithArgs({
    required String url,
    bool resetPreviousInstance = true,
    String windowTitle = "WebView",
    double? windowWidth,
    double? windowHeight,
    Function(String, String, FlutterError?)? onNavigationStart,
    Function(String, String, FlutterError?)? onNavigationCommit,
    Function(String, String, FlutterError?)? onNavigationError,
    Function(String, String, FlutterError?)? onNavigationFinished,
  }) {
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
    return methodChannel.invokeMethod("showWebViewWithArgs", {
      "url": url,
      "windowTitle": windowTitle,
      "resetPreviousInstance": true,
      "onNavigationStart": onNavigationStart != null,
      "onNavigationCommit": onNavigationCommit != null,
      "onNavigationError": onNavigationError != null,
      "onNavigationFinished": onNavigationFinished != null,
    });
  }

  @override
  Future<bool?> loadURL(String url) async {
    final result = await methodChannel.invokeMethod("loadURL", url);
    return result ?? false;
  }

  @override
  Future<void> loadHTMLString(String htmlString) async {
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
  Future<void> didFinish(
      Function(String, String, FlutterError?) didFinish) async {
    savedCallbacks["onNavigationFinish"] = didFinish;
    final bool _ = await methodChannel.invokeMethod("didFinish") ?? false;
    return;
  }

  @override
  Future<void> dismissWebView() async {
    final _ = await methodChannel.invokeMethod('dismissWebView');
    return;
  }

  Future<void> _genericMethodHandler(MethodCall call) async {
    switch (call.method) {
      case "onNavigationError":
        if (savedCallbacks["onNavigationError"] != null) {
          String resp = "";
          String url = "";
          if (call.arguments is List<dynamic>) {
            url = (call.arguments[0] ?? "") as String;
            resp = (call.arguments[1] ?? "") as String;
          } else if (call.arguments is FlutterError) {
            resp = (call.arguments as FlutterError).toString();
          }
          didFinishCallback!(url, resp, true);
        }
        break;
      default:
        break;
    }
  }
}
