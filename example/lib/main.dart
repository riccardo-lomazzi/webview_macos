import 'package:flutter/material.dart';
import 'package:webview_macos/webview_macos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialURL = "https://www.google.it";
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: initialURL);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Press the button to open the WebView'),
              TextField(
                controller: controller,
              ),
              MaterialButton(
                child: Text("Open WebView".toUpperCase()),
                onPressed: () async {
                  await WebviewMacos()
                      .showWebView(controller.text.toLowerCase().trim());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
