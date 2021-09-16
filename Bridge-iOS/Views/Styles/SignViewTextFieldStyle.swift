//
//  SignViewTextFieldStyle.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import Foundation

import SwiftUI

struct SignViewTextFieldStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.8)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 3)
    }
}
