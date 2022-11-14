import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_macos/exceptions.dart';

import 'webview_macos_method_channel.dart';

abstract class WebViewMacOSPlatform extends PlatformInterface {
  /// Constructs a NewWebviewMacosPlatform.
  WebViewMacOSPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebViewMacOSPlatform _instance = MethodChannelWebViewMacOS();

  /// The default instance of [WebViewMacOSPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebViewMacOS].
  static WebViewMacOSPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebViewMacOSPlatform] when
  /// they register themselves.
  static set instance(WebViewMacOSPlatform instance) {
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
