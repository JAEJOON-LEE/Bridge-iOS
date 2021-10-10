//
//  SpecialPostStyle.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import SwiftUI

struct SpecialPostStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.83,
                   height: UIScreen.main.bounds.height * 0.018)
            .padding()
            .foregroundColor(Color.black)
            .background(Color.white)
    }
}
