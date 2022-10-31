//
//  NSView+Extension.swift
//  webview_macos
//
//  Created by riccardo on 31/10/22.
//

import Foundation

extension NSView {
    func disposeOfEverySubview(){
        for view in self.subviews {
            view.disposeOfEverySubview()
        }
        self.removeFromSuperview()
    }
}
