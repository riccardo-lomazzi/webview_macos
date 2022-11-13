//
//  CG+Extension.swift
//  webview_macos
//
//  Created by riccardo on 01/11/22.
//

import Foundation

extension CGSize {
    static var defaultWindowSize: CGSize {
        CGSize(width: 1000, height: 600)
    }
}

extension CGRect {
    static var defaultWindowSize: CGRect {
        CGRect(x:0, y:0, width: 1000, height: 600)
    }
}
