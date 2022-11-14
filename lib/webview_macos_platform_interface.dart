import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_macos/exceptions.dart';

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

  Future<bool> showWebView({
    String? url,
    bool resetPreviousInstance = true,
    String windowTitle = "",
    Function(String, String, WebViewMacOSException?)? onNavigationStart,
    Function(String, String, WebViewMacOSException?)? onNavigationCommit,
    Function(String, String, WebViewMacOSException?)? onNavigationError,
    Function(String, String, WebViewMacOSException?)? onNavigationFinished,
    Function()? onWebViewOpened,
    Function()? onWebViewClosed,
    double? windowWidth,
    double? windowHeight,
  }) {
    throw UnimplementedError('showWebView() has not been implemented.');
  }

  Future<bool> loadURL(String url) {
    throw UnimplementedError('loadURL() has not been implemented.');
  }

  Future<bool> loadHTMLString(String htmlString) {
    throw UnimplementedError('loadHTMLString() has not been implemented.');
  }

  Future<String?> evaluateJavaScript(String jsString) {
    throw UnimplementedError('evaluateJavaScript() has not been implemented.');
  }

  Future<bool> isShowing() {
    throw UnimplementedError('isShowing() has not been implemented.');
  }

  Future<void> dismissWebView() {
    throw UnimplementedError('dismissWebView() has not been implemented.');
  }
}
