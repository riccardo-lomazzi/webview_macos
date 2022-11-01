import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'webview_macos_method_channel.dart';

abstract class WebviewMacosPlatform extends PlatformInterface {
  /// Constructs a NewWebviewMacosPlatform.
  WebviewMacosPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebviewMacosPlatform _instance = MethodChannelWebviewMacos();

  /// The default instance of [WebviewMacosPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebviewMacos].
  static WebviewMacosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebviewMacosPlatform] when
  /// they register themselves.
  static set instance(WebviewMacosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> showWebView(String initialURL, [bool reset = true]) {
    throw UnimplementedError('showWebView() has not been implemented.');
  }

  Future<void> showWebViewWithArgs({
    required String url,
    bool resetPreviousInstance = true,
    String windowTitle = "",
    Function(String, String, FlutterError?)? onNavigationStart,
    Function(String, String, FlutterError?)? onNavigationCommit,
    Function(String, String, FlutterError?)? onNavigationError,
    Function(String, String, FlutterError?)? onNavigationFinished,
    double? windowWidth,
    double? windowHeight,
  }) {
    throw UnimplementedError('showWebView() has not been implemented.');
  }

  Future<void> loadURL(String url) {
    throw UnimplementedError('loadURL() has not been implemented.');
  }

  Future<void> loadHTMLString(String htmlString) {
    throw UnimplementedError('loadHTMLString() has not been implemented.');
  }

  Future<String?> evaluateJavaScript(String jsString) {
    throw UnimplementedError('evaluateJavaScript() has not been implemented.');
  }

  Future<void> didFinish(Function(String, String, FlutterError?) onFinish) {
    throw UnimplementedError('didFinish() has not been implemented.');
  }

  Future<void> dismissWebView() {
    throw UnimplementedError('dismissWebView() has not been implemented.');
  }
}
