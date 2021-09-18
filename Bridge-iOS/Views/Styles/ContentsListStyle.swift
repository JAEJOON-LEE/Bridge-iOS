//
//  ContentsListStyle.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI

struct ContentsListStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.8)
            .padding()
            .foregroundColor(Color.white)
            .background(Color.mainTheme)
            .cornerRadius(20)
            .shadow(radius: 3)
    }
}
