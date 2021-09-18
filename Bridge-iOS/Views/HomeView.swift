//
//  HomeView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct ItemRow : View {
    @State var name : String
    @State var price : Int
    @State var camp : String
    @State var time : String
    @State var clicked : Bool = false
    @State var cnt : Int = 1
    
    var body : some View {
        HStack {
            Image("LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.title2)
                Text("$\(price)")
                    .font(.title)
                
                HStack {
                    Text("\(camp)")
                    Text("\(time)")
                    Image(systemName: "eye.fill")
                    Text("\(cnt)")
                }
                .font(.caption)
            }
            
            Spacer()
            
            // 하트 클릭하면 전체 클릭되는 문제 고쳐야함
            Button{
                print("heart is clicked")
                self.clicked = !self.clicked
            } label : {
                if self.clicked {
                    Image(systemName: "heart.fill")
                 } else {
                    Image(systemName: "heart")
                 }
            }
        }
        .frame(height : UIScreen.main.bounds.height * 0.1)
        .modifier(ContentsListStyle())
    }
}

struct HomeView : View {
    var body : some View {
        VStack(spacing: 0) {
            LocationPicker()
            
            List {
                Section(header: ListHeader(name : "WHAT'S NEW TODAY?")){
                    ItemRow(name: "Item1", price: 30, camp: "Camp Humphreys", time: "24:00")
                    ItemRow(name: "Item2", price: 30, camp: "Camp Carroll", time: "24:00")
                    ItemRow(name: "Item3", price: 30, camp: "Camp Casey", time: "24:00")
                    ItemRow(name: "Item4", price: 30, camp: "Camp Walker", time: "24:00")
                    ItemRow(name: "Item5", price: 30, camp: "Osan A/B", time: "24:00")
                }
            }
        }
    }
}
