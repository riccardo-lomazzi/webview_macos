import 'package:flutter/material.dart';
import 'package:webview_macos/webview_macos.dart';
import 'package:webview_macos/exceptions.dart';

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
                      onPressed: () async {
                        await WebViewMacOS.showWebView(
                          url: urlController.text.toLowerCase().trim(),
                          onNavigationStart: (String url, String html,
                              WebViewMacOSException? error) {
                            setState(() {});
                          },
                          onNavigationCommit: (String url, String html,
                              WebViewMacOSException? error) {},
                          onNavigationFinished: (String url, String html,
                              WebViewMacOSException? error) {
                            setState(() {
                              didFinishResult = "CURRENT URL: $url \n" + html;
                            });
                          },
                          onNavigationError: (String url, String html,
                              WebViewMacOSException? error) {
                            setState(() {
                              didFinishResult = "Error: \n" + error.toString();
                            });
                          },
                          onWebViewOpened: () {
                            setState(() {});
                          },
                          onWebViewClosed: () {
                            setState(() {});
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
                        "onNavigationFinished Result",
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
                FutureBuilder<bool>(
                  future: WebViewMacOS.isShowing(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == false) {
                      return Container();
                    }
                    return Column(
                      children: [
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
                                String? result =
                                    await WebViewMacOS.evaluateJavaScript(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text("Clear Data Store".toUpperCase()),
                              onPressed: () async {
                                bool result =
                                    await WebViewMacOS.clearDataStore();
                                if (result) {
                                  setState(() {
                                    javascriptResult = "Cleared Data Store";
                                  });
                                }
                              },
                            ),
                            MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text("Close WebView".toUpperCase()),
                              onPressed: () async {
                                WebViewMacOS.dismissWebView();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
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
