//
//  BoardView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct HotContent : View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("내용")
                
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("10")
                    
                    Image(systemName: "message")
                    Text("5")
                }
            }
            
            Spacer()
            
            Button(action:{print("clicked details")}){
                            Image(systemName: "arrow.forward")
                                .padding()
            }
        }
    }
}

struct GeneralContent : View {
    var body : some View {
        HStack{
            Text("내용")
            Spacer()
            
            Image(systemName: "hand.thumbsup.fill")
            Text("10")
            
            Image(systemName: "message")
            Text("5")
        }
    }
}

struct BoardView : View {
    var body : some View {
        
        VStack(spacing: 0) {
            LocationPicker()
            
            // style이 section 컴포넌트들 각각에 적용되는거 해결해야함
            VStack{
                Spacer()
                
                List {
                    //Hot board
                    Section(header: ListHeader(name : "Hot Board")){
                        HotContent()
                        HotContent()
                        HotContent()
                    }
                }
                .frame(width : UIScreen.main.bounds.width * 0.95)
                .cornerRadius(20)
                .shadow(radius: 3)
                
                List {
                    //Bug report
                    Section(header: ListHeader(name : "Bug Report")){
                        HotContent()
                        HotContent()
                        HotContent()
                    }
                }
                .frame(width : UIScreen.main.bounds.width * 0.95)
                .cornerRadius(20)
                .shadow(radius: 3)
                
                List {
                    //일반 게시물
                    Section(header: ListHeader(name : "Bulltein")){
                        GeneralContent()
                        GeneralContent()
                        GeneralContent()
                    }
                }
            }
        }
    }
}
