//
//  UIDevice+Extension.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/02/03.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    // EX) SomeView().background(UIDevice.current.hasNotch ? Color.red : Color.yellow)
}
