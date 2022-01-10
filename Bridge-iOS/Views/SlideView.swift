//
//  SlideView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/18.
//

import SwiftUI
import URLImage

struct SlideItem : View {
    var ImageName : String
    var text : String
    
    var body : some View {
        HStack{
            Image(systemName: ImageName)
                .foregroundColor(.mainTheme)
            Text(text)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
        }
    }
}

struct SlideView : View {
    @AppStorage("rememberUser") var rememberUser : Bool = false

    @StateObject private var viewModel : SlideViewModel
    
    init(viewModel : SlideViewModel) {
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
                ForEach(viewModel.playPostLists, id : \.self) { PostList in
                    VStack {
                        NavigationLink(
                            destination:
                                PostInfoView(viewModel: PostInfoViewModel(
                                    token: viewModel.userInfo.token.accessToken,
                                    postId : PostList.postId,
                                    memberId : viewModel.userInfo.memberId,
                                    isMyPost : (PostList.postType == "board" ? true : nil)))
                        ) {
                            HStack(spacing : 13) {
                                URLImage(
                                    URL(string : PostList.image!) ??
                                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                                ) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width : UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.12)
                                .cornerRadius(10)

                                VStack(alignment : .leading, spacing: 5) {
                                    Text(PostList.title)
//                                        .font(.title2)
                                        .font(.system(size: 22, weight : .bold, design : .rounded))
                                        .foregroundColor(.black)
                                    HStack {
                                        Text(PostList.description)
                                            .font(.system(size: 20, weight : .bold))
                                            .foregroundColor(.black)
                                            .fontWeight(.light)
//                                        Spacer()
//                                        Image(systemName : "hand.thumbsup.fill")
//                                            .font(.system(size : 15))
                                    }
                                    Spacer()
                                    HStack(spacing : 5) {
                                        Spacer()
                                        Text(convertReturnedDateString(PostList.createdAt))
                                            .fontWeight(.light)
                                            .padding(.horizontal)
                                        Image(systemName : "message.fill")
                                        Text("\(PostList.commentCount)")
                                            .fontWeight(.light)
                                        Image(systemName : "hand.thumbsup.fill")
                                        Text("\(PostList.likeCount)")
                                            .fontWeight(.light)
                                    }.font(.system(size : 9))
                                }.foregroundColor(.secondary)
                                .padding(.vertical, 5)
                            }
                            .padding(5)
                            .padding(.horizontal, 10)
                            //.modifier(ItemCardStyle())
                        }
                        
                        Color.systemDefaultGray
                            .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                    }
                }
            }.onAppear {
                viewModel.getBoardPosts(token: viewModel.userInfo.token.accessToken)
            }
        }.navigationTitle(Text("My Posts"))
    }

    var body : some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing : 15) {
                HStack {
                    Spacer()
                    Button{
                        // user info edit api call!
                    } label : {
                        HStack {
                            Text("Edit")
                            Image(systemName: "pencil.circle")
                        }
                        .foregroundColor(.gray)
                        .font(.system(size : 12, weight: .semibold))
                    }
                }
                
                HStack(spacing : 20) {
                    URLImage(URL(string: viewModel.userInfo.profileImage)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width : UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.width * 0.2)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing : 15) {
                        Text(viewModel.userInfo.username)
                            .font(.system(size : 20, weight : .bold))
                            //.fontWeight(.bold)
                        Text("\"" + viewModel.userInfo.description + "\"")
                    }
                }
                .padding(.leading, 10)
                
                HStack {
                    NavigationLink {
                        sellingItems
                    } label : {
                        VStack {
                            Image(systemName : "cart")
                                .font(.system(size : 30))
                            Text("Selling list")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                    
                    NavigationLink {
                        postsIWrote
                    } label : {
                        VStack {
                            Image(systemName : "list.bullet.rectangle")
                                .font(.system(size : 30))
                            Text("Post list")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                    
                    NavigationLink {
                        likedItems
                    } label : {
                        VStack {
                            Image(systemName : "heart")
                                .font(.system(size : 30))
                            Text("Like item")
                                .font(.system(size : 10))
                        }
                        .padding()
                        .foregroundColor(.gray)
                    }
                }
                .frame(width : UIScreen.main.bounds.width * 0.7, height : UIScreen.main.bounds.height * 0.1)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.vertical, 10)
                
                
                VStack(alignment : .leading,spacing : 30) {
                    Button{
                        print("home is clicked")
                    } label : {
                        SlideItem(ImageName: "house", text: "Home")
                    }
                    
                    Button{
                        print("Membership is clicked")
                    } label : {
                        SlideItem(ImageName: "creditcard", text: "Membership")
                    }
                    
                    Button{
                        print("Seller Page is clicked")
                    } label : {
                        SlideItem(ImageName: "person", text: "Seller page")
                    }
                    
                    NavigationLink(destination: InviteFriendsView()) {
                        SlideItem(ImageName: "person", text: "Invite friends")
                    }
                    
                    Button{
                        print("Customer Service is clicked")
                    } label : {
                        SlideItem(ImageName: "info.circle", text: "Customer Service")
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView(viewModel: SettingsViewModel(signInResponse: viewModel.userInfo))) {
                        SlideItem(ImageName: "gearshape", text: "Setting")
                    }.padding(.bottom, 20)
                }
                .padding(.leading, 10)
            }
            .padding(20)
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .background(
                Image("myPage_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
            )
        }
    }
}

//struct SlideView_Previews: PreviewProvider {
//    static var previews: some View {
//        SlideView(viewModel: SlideViewModel())
//    }
//}
