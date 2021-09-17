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

    @State var isOn1 = false
    @State var isOn2 = false
    
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
            HStack{
                Toggle("Anonymous", isOn: $isOn1)
                Spacer()
                Toggle("Bug Report", isOn: $isOn2)
                Image(systemName: "camera").padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            }
            .padding(10)
            .font(.caption)
            
            Spacer()
            
            Button("Upload") { }
                .modifier(SubmitButtonStyle())
            
            Spacer()
            
            // 탭 가려지는거 해결해야함
            Text("asdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddas")
                .font(.caption2)
        }.padding()
    }
}


struct Previews: PreviewProvider {
    static var previews: some View {
        WritingView()
    }
}
