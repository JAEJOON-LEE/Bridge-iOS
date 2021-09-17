//
//  BoardView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct ListHeader : View {
    @State var name : String
    
    var body: some View {
        HStack{
            Text(name)
                .foregroundColor(Color.yellow)
            Spacer()
            Button(action: {}, label: {
                Text("more")
            })
        }
    }
}

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
        VStack {
            LocationPicker()
            
            HStack{
                List {
                    //Hot board
                    Section(header: ListHeader(name : "Hot Board")){
                        HotContent()
                        HotContent()
                        HotContent()
                    }
                    
                    //Bug report
                    Section(header: ListHeader(name : "Bug Report")){
                        HotContent()
                        HotContent()
                        HotContent()
                    }
                    
                    //others
                    Spacer()
                    
                    GeneralContent()
                    GeneralContent()
                    GeneralContent()
                    GeneralContent()
                    GeneralContent()
                }
            }
        }
    }
}
