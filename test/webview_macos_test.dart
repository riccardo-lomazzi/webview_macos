import 'package:flutter/src/foundation/assertions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_macos/webview_macos_method_channel.dart';
import 'package:webview_macos/webview_macos_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNewWebviewMacosPlatform
    with MockPlatformInterfaceMixin
    implements WebviewMacosPlatform {
  @override
  Future<void> dismissWebView() {
    throw UnimplementedError();
  }

  @override
  Future<String?> evaluateJavaScript(String jsString) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadHTMLString(String htmlString) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadURL(String url) {
    throw UnimplementedError();
  }

  @override
  Future<void> showWebView(String initialURL, [bool reset = true]) {
    throw UnimplementedError();
  }

  @override
  Future<void> didFinish(Function(String, String, FlutterError?) didFinish) {
    throw UnimplementedError();
  }

  @override
  Future<void> showWebViewWithArgs(
      {required String url,
      bool resetPreviousInstance = true,
      String windowTitle = "",
      Function(String p1, String p2, FlutterError? p3)? onNavigationStart,
      Function(String p1, String p2, FlutterError? p3)? onNavigationCommit,
      Function(String p1, String p2, FlutterError? p3)? onNavigationError,
      Function(String p1, String p2, FlutterError? p3)? onNavigationFinished,
      double? windowWidth,
      double? windowHeight}) {
    throw UnimplementedError();
  }
}

void main() {
  final WebviewMacosPlatform initialPlatform = WebviewMacosPlatform.instance;

  test('$MethodChannelWebviewMacos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebviewMacos>());
  });
}
