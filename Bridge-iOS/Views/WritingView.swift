//
//  WritingView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct WritingView : View {
    @State var contentTitle : String = ""
    @State var content : String = ""
    
    var body: some View {
        VStack(spacing : 20) {
            //LocationPicker()
            HStack {
                Text("Board Writing")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal, 20)
            TextField("title", text: $contentTitle)
                .modifier(SignViewTextFieldStyle())
            TextField("titleContent", text: $content)
                .frame(height : UIScreen.main.bounds.height * 0.3)
                .modifier(SignViewTextFieldStyle())
            Spacer()
            Button("Upload") {
                
            }
            .foregroundColor(.white)
            .frame(width : UIScreen.main.bounds.width * 0.8)
            .padding()
            .background(Color.mainTheme)
            .cornerRadius(20)
            .shadow(radius: 3)
        }.padding()
    }
}


struct Previews: PreviewProvider {
    static var previews: some View {
        WritingView()
    }
}
