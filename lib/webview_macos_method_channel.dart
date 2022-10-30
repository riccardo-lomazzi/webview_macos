import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview_macos_platform_interface.dart';

/// An implementation of [WebviewMacosPlatform] that uses method channels.
class MethodChannelWebviewMacos extends WebviewMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('new_webview_macos');

  @override
  Future<void> showWebView(String initialURL) async {
    final _ = await methodChannel.invokeMethod('showWebView', initialURL);
    return;
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
  Future<void> dismissWebView() async {
    final _ = await methodChannel.invokeMethod('dismissWebView');
    return;
  }
}
