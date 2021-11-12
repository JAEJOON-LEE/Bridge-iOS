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
            .padding(10)
            .background(Color.systemDefaultGray)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
    }
}
