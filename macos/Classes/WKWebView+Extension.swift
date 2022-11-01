//
//  WKWebView+Extension.swift
//  webview_macos
//
//  Created by riccardo on 01/11/22.
//

import Foundation
import WebKit

extension WKWebView {
    
    func getInnerHTML(completionHandler: @escaping (String, Error?) -> Void) {
        self.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
            var unwrappedInnerHTML: String = ""
            if let innHTML = innerHTML as? String {
                unwrappedInnerHTML = innHTML
            }
            completionHandler(unwrappedInnerHTML, error)
        }
        
    }
    
}
