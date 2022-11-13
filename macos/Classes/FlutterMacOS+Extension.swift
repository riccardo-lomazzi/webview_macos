//
//  FlutterMacOS+Extension.swift
//  webview_macos
//
//  Created by riccardo on 13/11/22.
//

import Foundation
import FlutterMacOS

extension FlutterError {
    var toMap: [String: Any] {
        return [
            "code": self.code,
            "message": self.message ?? "",
            "details": self.details ?? nil
        ]
    }
}
