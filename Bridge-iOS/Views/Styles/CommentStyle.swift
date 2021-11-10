//
//  CommentStyle.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import SwiftUI

struct CommentStyle : ViewModifier {
    func body(content : Content) -> some View {
        return content
            .frame(width : UIScreen.main.bounds.width * 0.83)
            .padding()
            .foregroundColor(Color.black)
//            .background(Color.white) 
    }
}
