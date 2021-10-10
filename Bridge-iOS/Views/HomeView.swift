//
//  HomeView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage

struct HomeView : View {
    @StateObject private var viewModel : HomeViewModel
    
    init(viewModel : HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack(spacing: 0) {
            LocationPicker()
            ListHeader(name: "What's new today?").padding(.vertical, 10)

            List {
                ForEach(viewModel.Posts, id : \.self) { Post in
                    NavigationLink(
                        destination:
                            ItemInfoView(viewModel:
                                            ItemInfoViewModel(
                                                token: viewModel.token,
                                                postId : Post.postId,
                                                isMyPost : (viewModel.memberId == Post.memberId)
                                            )
                            ).onDisappear(perform: {
                                viewModel.getPosts(token: viewModel.token)
                            })
                    ) {
                        ItemCard(viewModel : ItemCardViewModel(post: Post))
                    }
                }
            }.listStyle(PlainListStyle()) // iOS 15 대응
        }.onAppear {
            viewModel.getPosts(token: viewModel.token)
        }
    }
}

struct ItemCard : View {
    private let viewModel : ItemCardViewModel
    
    init(viewModel : ItemCardViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        HStack(spacing : 15) {
            URLImage(
                URL(string : viewModel.imageUrl) ??
                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
            ) { image in
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
                Text("$ " + viewModel.itemPrice)
                    .font(.system(size: 20, weight : .medium))
                Spacer()
                HStack {
                    Text(viewModel.camp)
                    Image(systemName : "eye")
                    Text("\(viewModel.viewCount)")
                    Spacer()
                    Image(systemName : viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.system(size : 20))
                }.font(.system(size : 12))
            }.foregroundColor(.secondary)
        }
        .modifier(ItemCardStyle())
    }
}
