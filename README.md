# WebView MacOS

Flutter stub implementation of WKWebView for MacOS.
Feel free to fork this repository and improve it!

## Getting Started

- [Basic usage](#basic-usage)
- [Limitations and notes](#limitations-and-notes)
- [License](#license)

---

## Basic usage

Call ```showWebView(String initialURL)``` to show a WKWebView in a new window.

```
WebviewMacos().showWebView("https://github.com");
```

Call ```loadURL(String URL)``` or ```loadHTMLString(String htmlString)``` to load a new URL or a HTML page, respectively.

Call ```evaluateJavaScript(String javascriptString)``` to evaluate a Javascript string and return the result.
```
final String? result = await WebviewMacos().evaluateJavaScript("document.getElementByName('div').innerHTML");
```


## Limitations and notes

- Multiple instances of the webview are not currently supported.
- The ```WebView``` object isn't fully customizable, it is limited to "cache reset" single requests.
- There isn't a ```WebViewController``` object to manage the WebView lifecycle, instead you have to call the single methods.
- Currently the ```Webview``` is limited to run in a new ```NSWindow```. Future developments will include the chance to present the WebView in various ways, such as ```presentAsSheet```.

## License

[MIT](https://github.com/riccardo-lomazzi/webview_macos/blob/main/LICENSE)

