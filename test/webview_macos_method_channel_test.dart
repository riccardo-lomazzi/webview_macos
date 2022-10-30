import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_macos/webview_macos_method_channel.dart';

void main() {
  MethodChannelWebviewMacos platform = MethodChannelWebviewMacos();
  const MethodChannel channel = MethodChannel('webview_macos_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
