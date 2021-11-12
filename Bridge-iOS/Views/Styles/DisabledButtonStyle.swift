//
//  SubmitButtonStyle.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/17.
//

import SwiftUI

struct DisabledButtonStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.8)
            .padding()
            .foregroundColor(.black)
            .background(Color.systemDefaultGray)
            .cornerRadius(20)
            .shadow(radius: 3)
    }
}
