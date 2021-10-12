//
//  ContentsListStyle.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI

struct ItemCardStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.86,
                   height: UIScreen.main.bounds.height * 0.1)
            .padding()
            .foregroundColor(Color.white)
            .background(Color.systemDefaultGray)
            .cornerRadius(20)
            .shadow(radius: 2)
            .padding(.vertical, 3)
    }
}
