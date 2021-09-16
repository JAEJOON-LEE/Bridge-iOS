//
//  LocationPicker.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI

struct LocationPicker : View {
    @State private var selectedLocation = "Camp Casey"
    let locations = [
        "Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humpreys", "Camp Carroll", "Camp Henry", "Camp Worker", "Gunsan A/B"
    ]
    
    var body : some View {
        HStack (spacing : 15) {
            // Location Picker
            Text(selectedLocation)
                .fontWeight(.semibold)
            Picker("▼", selection: $selectedLocation) {
                ForEach(locations, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            Spacer()
            Button{
                print("search button clicked")
            } label : {
                Image(systemName: "magnifyingglass")
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.systemDefaultGray)
    }
}
