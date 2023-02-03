# WebView macOS

```Flutter``` stub implementation of ```WKWebView``` for ```macOS```.
Feel free to fork this repository and improve it!

## Getting Started

- [Basic usage](#basic-usage)
- [Limitations and notes](#limitations-and-notes)
- [License](#license)

---

## Basic usage

Call ```showWebView(String initialURL)``` to show a ```WKWebView``` in a new window.

```
WebViewMacOS.showWebView("https://github.com");
```

Call ```WebViewMacOS.loadURL(String URL)``` or ```WebViewMacOS.loadHTMLString(String htmlString)``` to load a new URL or a HTML page, respectively.

Call ```WebViewMacOS.evaluateJavaScript(String javascriptString)``` to evaluate a Javascript string and return the result.
```
final String? result = await WebViewMacOS.evaluateJavaScript("document.getElementByName('div').innerHTML");
```
Call ```WebViewMacOS.clearDataStore()``` to clear all the cookies, local and session storage.


## Limitations and notes

- Due to a ```Texture``` limitation on macOS Flutter engine, ```WKWebView``` is limited to run in a new ```NSWindow```.
- Multiple instances of the webview are currently not supported. 

## License

[MIT](https://github.com/riccardo-lomazzi/webview_macos/blob/main/LICENSE)

