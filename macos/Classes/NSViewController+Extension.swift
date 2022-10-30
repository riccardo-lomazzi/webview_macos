//
//  NSViewController+Extension.swift
//  new_webview_macos
//
//  Created by riccardo on 30/10/22.
//

import Foundation

extension NSViewController {

   func presentInNewWindow(viewController: NSViewController) {
      let window = NSWindow(contentViewController: viewController)

      var rect = window.contentRect(forFrameRect: window.frame)
      // Set your frame width here
      rect.size = .init(width: 1000, height: 600)
      let frame = window.frameRect(forContentRect: rect)
      window.setFrame(frame, display: true, animate: true)

      window.makeKeyAndOrderFront(self)
      let windowVC = NSWindowController(window: window)
      windowVC.showWindow(self)
  }
}
