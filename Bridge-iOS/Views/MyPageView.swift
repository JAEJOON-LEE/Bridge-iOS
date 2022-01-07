//
//  MyPageView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import SwiftUI
import URLImage

struct MyPageView: View {
    @StateObject private var viewModel : MyPageViewModel
    
    init(viewModel : MyPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack {
            Spacer()
                .frame(height : UIScreen.main.bounds.height * 0.1)
            URLImage(URL(string: viewModel.userInfo.profileImage)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(
                width : UIScreen.main.bounds.width * 0.4,
                height : UIScreen.main.bounds.width * 0.4
            )
            .clipShape(Circle())
            .shadow(radius: 5)
            
            Text(viewModel.userInfo.username)
                .font(.title)
                .fontWeight(.bold)
            Text(viewModel.userInfo.description)
                .font(.title)
            Spacer()
        }
        .padding()
        .navigationTitle(Text("My Account"))
    }
}
