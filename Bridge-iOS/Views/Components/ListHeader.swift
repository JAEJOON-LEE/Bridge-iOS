//
//  ListHeader.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI

struct ListHeader : View {
    @State var name : String
    
    var body: some View {
        HStack{
            Text(name)
                .foregroundColor(Color.yellow)
                .font(.title2)
                .padding()
            Spacer()
            Button(action: {}, label: {
                Text("more")
            })
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05)
        .background(Color.white)
    }
}
