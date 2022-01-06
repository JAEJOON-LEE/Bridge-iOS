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
    
    var sellingItems : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.usedPostList, id : \.self) { Post in
                    VStack {
                        NavigationLink(
                            destination:
                                ItemInfoView(viewModel:
                                                ItemInfoViewModel(
                                                    token: viewModel.userInfo.token.accessToken,
                                                    postId : Post.postId,
                                                    isMyPost : (viewModel.userInfo.memberId == Post.postId)
                                                )
                                )
                        ) {
                            ItemCard(viewModel : ItemCardViewModel(post: Post))
                        }
                        
                        Color.systemDefaultGray
                            .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                    }
                }
            }.onAppear {
                viewModel.getSellingList()
            }
        }.navigationTitle(Text("Selling Items"))
    }
    var likedItems : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.likedPostList, id : \.self) { Post in
                    VStack {
                        NavigationLink(
                            destination:
                                ItemInfoView(viewModel:
                                                ItemInfoViewModel(
                                                    token: viewModel.userInfo.token.accessToken,
                                                    postId : Post.postId,
                                                    isMyPost : (viewModel.userInfo.memberId == Post.postId)
                                                )
                                )
                        ) {
                            ItemCard(viewModel : ItemCardViewModel(post: Post))
                        }
                        
                        Color.systemDefaultGray
                            .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                    }
                }
            }.onAppear {
                viewModel.getLikedList()
            }
        }.navigationTitle(Text("Liked Items"))
    }
    var postsIWrote : some View {
        ScrollView {
            LazyVStack {
                Text("Element 1")
                Text("Element 2")
                Text("Element 3")
            }
        }.navigationTitle(Text("Posts I Wrote"))
    }
    
    var body : some View {
        VStack {
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
                .frame(height : UIScreen.main.bounds.height * 0.2)
            NavigationLink(destination: sellingItems) {
                HStack {
                    Image(systemName: "shippingbox")
                    Text("Selling items")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical, 5)
                .foregroundColor(.black)
            }
            Divider()
            NavigationLink(destination: likedItems) {
                HStack {
                    Image(systemName: "hand.thumbsup.circle")
                    Text("Liked items")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical, 5)
                .foregroundColor(.black)
            }
            Divider()
            NavigationLink(destination: postsIWrote) {
                HStack {
                    Image(systemName: "text.alignleft")
                    Text("Posts I wrote")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.vertical, 5)
                .foregroundColor(.black)
            }
            Divider()
        }
        .padding()
        .navigationTitle(Text("My Account"))
    }
}
