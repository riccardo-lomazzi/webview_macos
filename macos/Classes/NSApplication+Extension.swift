//
//  NSApplication+Extension.swift
//  webview_macos
//
//  Created by riccardo on 31/10/22.
//

import Foundation
import FlutterMacOS

extension NSApplication {
    static var mainFlutterController: NSViewController? {
        if let delegate = shared.delegate as? FlutterAppDelegate, let window = delegate.mainFlutterWindow {
            return window.contentViewController
        } else {
            return nil
        }
    }
}
