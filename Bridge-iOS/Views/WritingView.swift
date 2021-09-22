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
            }.padding(20)
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
            .padding(.horizontal, 30)
            .font(.caption)
                        
            Button("Upload") { }
                .modifier(SubmitButtonStyle())
                
            Text("Policy Text Area : asdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddasdsbgaddas")
                .font(.caption2)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}


struct Previews: PreviewProvider {
    static var previews: some View {
        WritingView()
    }
}
