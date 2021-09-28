//
//  HomeView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage

struct ItemCard : View {
    private let viewModel : ItemCardViewModel
    
    init(viewModel : ItemCardViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        HStack(spacing : 15) {
            URLImage(URL(string : viewModel.imageUrl)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width : UIScreen.main.bounds.width * 0.25,
                   height: UIScreen.main.bounds.height * 0.1)
            .cornerRadius(10)

            VStack(alignment : .leading){
                Text(viewModel.itemTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("$ \(viewModel.itemPrice)")
                    .font(.system(size: 20, weight : .medium))
                Spacer()
                HStack {
                    Text(viewModel.camp)
                    Image(systemName : "eye")
                    Text("\(viewModel.viewCount)")
                    Spacer()
                    Image(systemName : viewModel.isLiked ? "heart" : "heart.fill")
                        .font(.system(size : 20))
                }.font(.system(size : 12))
            }.foregroundColor(.secondary)
        }
        .modifier(ItemCardStyle())
    }
}

struct HomeView : View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body : some View {
        VStack(spacing: 0) {
            LocationPicker()
            ListHeader(name: "What's new today?").padding(.vertical, 10)
            List {
                ForEach(viewModel.Posts, id : \.self) { Post in
                    ItemCard(viewModel : ItemCardViewModel(post: Post))
                }
            }.listStyle(PlainListStyle()) // iOS 15 대응
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
