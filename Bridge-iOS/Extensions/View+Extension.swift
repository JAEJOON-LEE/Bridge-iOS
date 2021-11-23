//
//  View+Extension.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/13.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
