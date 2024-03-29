import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_macos/exceptions.dart';
import 'package:webview_macos/webview_macos_method_channel.dart';
import 'package:webview_macos/webview_macos_platform_interface.dart';

class MockNewWebviewMacosPlatform
    with MockPlatformInterfaceMixin
    implements WebViewMacOSPlatform {
  @override
  Future<void> dismissWebView() {
    throw UnimplementedError();
  }

  @override
  Future<String?> evaluateJavaScript(String jsString) {
    throw UnimplementedError();
  }

  @override
  Future<bool> loadHTMLString(String htmlString) {
    throw UnimplementedError();
  }

  @override
  Future<bool> loadURL(String url) {
    throw UnimplementedError();
  }

  @override
  Future<bool> showWebView({
    String? url,
    bool resetPreviousInstance = true,
    String windowTitle = "",
    Function(String p1, String p2, WebViewMacOSException? p3)?
        onNavigationStart,
    Function(String p1, String p2, WebViewMacOSException? p3)?
        onNavigationCommit,
    Function(String p1, String p2, WebViewMacOSException? p3)?
        onNavigationError,
    Function(String p1, String p2, WebViewMacOSException? p3)?
        onNavigationFinished,
    double? windowWidth,
    double? windowHeight,
    Function()? onWebViewOpened,
    Function()? onWebViewClosed,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isShowing() {
    throw UnimplementedError();
  }

  @override
  Future<bool> clearDataStore() {
    throw UnimplementedError();
  }
}

void main() {
  final WebViewMacOSPlatform initialPlatform = WebViewMacOSPlatform.instance;

  test('$MethodChannelWebViewMacOS is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebViewMacOS>());
  });
}
