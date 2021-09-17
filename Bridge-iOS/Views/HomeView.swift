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
    var body : some View {
        HStack {
            Image("LOGO")
            
            VStack(alignment: .leading) {
                Text("\(name)")
                Text("$\(price)")
                
                HStack {
                    Text("\(camp)")
                    Text("\(time)")
                }
            }
            .font(.caption)
            
            Spacer()
            
            // 하트 클릭하면 전체 클릭되는 문제 고쳐야함
            Button{
                print("heart is clicked")
                self.clicked = !self.clicked
            } label : {
                if self.clicked {
                    Image(systemName: "heart")
                 } else {
                    Image(systemName: "heart.fill")
                 }
            }
        }
    }
}

struct HomeView : View {
    var body : some View {
        VStack {
            LocationPicker()
            
            List {
                Section(header: Text("What's new today?")){
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
