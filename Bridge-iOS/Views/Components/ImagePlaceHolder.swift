//
//  ImagePlaceHolder.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/02/09.
//

import SwiftUI

struct ImagePlaceHolder : View {
    var body : some View {
        VStack {
            Image("LOGO")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(5)
            ProgressView()
        }.frame(maxWidth : .infinity, maxHeight : .infinity)
    }
}
