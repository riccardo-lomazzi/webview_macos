//
//  NSViewController+Extension.swift
//  new_webview_macos
//
//  Created by riccardo on 30/10/22.
//

import Foundation

extension NSViewController {
    
    func presentInNewWindow(viewController: NSViewController, windowTitle: String = "", windowSize: CGSize = CGSize(width: 1000, height: 600)) -> NSWindowController {
        let window = NSWindow(contentViewController: viewController)
        
        var rect = window.contentRect(forFrameRect: window.frame)
        rect.size = windowSize
        let frame = window.frameRect(forContentRect: rect)
        window.setFrame(frame, display: true, animate: true)
        
        window.makeKeyAndOrderFront(self)
        window.title = windowTitle
        let windowVC = NSWindowController(window: window)
        windowVC.showWindow(self)
        
        return windowVC
    }
    
}
