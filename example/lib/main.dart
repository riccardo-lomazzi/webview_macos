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
  late TextEditingController urlController;
  late TextEditingController javaScriptController;
  String javascriptResult = "";
  String didFinishResult = "";

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: initialURL);
    javaScriptController = TextEditingController(
      text: "document.getElementsByTagName('body')[0].innerHTML",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebView MacOS example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Open the WebView before evaluating Javascript'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          labelText: "URL",
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Open WebView".toUpperCase()),
                      onPressed: () {
                        WebviewMacos.showWebView(
                          url: urlController.text.toLowerCase().trim(),
                          onNavigationStart:
                              (String url, String html, FlutterError? error) {},
                          onNavigationCommit:
                              (String url, String html, FlutterError? error) {},
                          onNavigationFinished:
                              (String url, String html, FlutterError? error) {
                            setState(() {
                              didFinishResult = "CURRENT URL: $url \n" + html;
                            });
                          },
                          onNavigationError:
                              (String url, String html, FlutterError? error) {
                            setState(() {
                              didFinishResult = "Error: \n" + error.toString();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DidFinish Result",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            didFinishResult,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: javaScriptController,
                        decoration: InputDecoration(
                          labelText: "Evaluate Javascript",
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Evaluate Javascript".toUpperCase()),
                      onPressed: () async {
                        String? result = await WebviewMacos.evaluateJavaScript(
                            javaScriptController.text.trim());
                        setState(() {
                          javascriptResult = result ?? "Error";
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Javascript result",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            javascriptResult,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Close WebView".toUpperCase()),
                  onPressed: () async {
                    WebviewMacos.dismissWebView();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
