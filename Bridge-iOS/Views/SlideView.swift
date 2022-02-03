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
    @AppStorage("userEmail") var userEmail : String = ""
    @AppStorage("userPW") var userPW : String = ""
    
    @StateObject private var viewModel : SlideViewModel
    
    init(viewModel : SlideViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var sellingItems : some View {
        VStack(spacing : 0) {
            Text("Selling Items")
                .padding()
                .frame(maxWidth : .infinity)
                .font(.headline)
                .padding(.top, UIDevice.current.hasNotch ? UIScreen.main.bounds.height * 0.05 : UIScreen.main.bounds.height * 0.02)
            
            Divider()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.usedPostList, id : \.self) { Post in
                        VStack {
                            NavigationLink(
                                destination:
                                    ItemInfoView(viewModel:
                                                    ItemInfoViewModel(
                                                        postId : Post.postId,
                                                        isMyPost : true,//(viewModel.userInfo.memberId == Post.memberId),
                                                        userInfo: viewModel.memberInfo
                                                    )
                                    )
                            ) {
                                ItemCard(viewModel : ItemCardViewModel(post: Post), isMyPost: true)
                            }
                            
                            Color.systemDefaultGray
                                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                        }
                    }
                }.onAppear {
                    viewModel.getSellingList()
                }
            }
        }.navigationTitle(Text(""))
        .edgesIgnoringSafeArea(.top)
    }
    
    var likedItems : some View {
        VStack(spacing : 0) {
            Text("Liked Items")
                .padding()
                .frame(maxWidth : .infinity)
                .font(.headline)
                .padding(.top, UIDevice.current.hasNotch ? UIScreen.main.bounds.height * 0.05 : UIScreen.main.bounds.height * 0.02)
            
            Divider()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.likedPostList, id : \.self) { Post in
                        VStack {
                            NavigationLink(
                                destination:
                                    ItemInfoView(viewModel:
                                                    ItemInfoViewModel(
                                                        postId : Post.postId,
                                                        isMyPost : (viewModel.userInfo.memberId == Post.postId),
                                                        userInfo: viewModel.memberInfo
                                                    )
                                    )
                            ) {
                                ItemCard(viewModel : ItemCardViewModel(post: Post), isMyPost: false)
                            }
                            
                            Color.systemDefaultGray
                                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                        }
                    }
                }.onAppear {
                    viewModel.getLikedList()
                }
            }
        }.navigationTitle(Text(""))
        .edgesIgnoringSafeArea(.top)
    }
    
    var postsIWrote : some View {
        VStack(spacing : 0) {
            Text("My Posts")
                .padding()
                .frame(maxWidth : .infinity)
                .font(.headline)
                .padding(.top, UIDevice.current.hasNotch ? UIScreen.main.bounds.height * 0.05 : UIScreen.main.bounds.height * 0.02)
            
            Divider()
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
            }
        }.navigationTitle(Text(""))
        .edgesIgnoringSafeArea(.top)
    }

    var body : some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing : 15) {
                HStack {
                    Spacer()
                    NavigationLink(destination: MyPageView(viewModel: MyPageViewModel(memberInformation: viewModel.memberInfo))) {
                        Text("Edit")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                }
                
                HStack(spacing : 20) {
                    URLImage(URL(string: viewModel.memberInfo.profileImage)
                             ?? URL(string : "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width : UIScreen.main.bounds.width * 0.2, height : UIScreen.main.bounds.width * 0.2)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing : 10) {
                        Text(viewModel.memberInfo.username)
                            .font(.system(size : 20, weight : .bold))
                        Text(viewModel.memberInfo.description)
                    }
                }.padding(.leading, 10)
                
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
                
                
                VStack(alignment : .leading, spacing : 30) {
                    NavigationLink(destination : UserSuggestionView()) {
                        SlideItem(ImageName: "person", text: "User Suggestion")
                    }
                    NavigationLink(destination: InviteFriendsView()) {
                        SlideItem(ImageName: "person.badge.plus", text: "Invite friends")
                    }
                    NavigationLink(destination : SettingsView(viewModel : SettingsViewModel(memberInformation : viewModel.memberInfo))) {
                        SlideItem(ImageName: "gearshape", text: "Setting")
                    }
                    // Customer Service
                    NavigationLink(destination : Text("Customer service")) {
                        SlideItem(ImageName: "questionmark.circle", text: "Customer Service")
                    }
                    
                    Spacer()
                    
                    Button{
                        viewModel.isSignOutClicked = true
                    } label : {
                        SlideItem(ImageName: "arrow.right.square", text: "Logout")
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
            .onAppear { viewModel.getUserInfo() }
            .actionSheet(isPresented: $viewModel.isSignOutClicked) {
                ActionSheet(
                    title: Text("Do you really want to logout?"),
                    buttons: [
                        .destructive(Text("Log Out")) {
                            userEmail = ""
                            userPW = ""
                            rememberUser = false
                            viewModel.signOut()
                            viewModel.signOutConfirm = true
                        },
                        .cancel()
                    ]
                )
            }
            .background(
                NavigationLink(
                    destination : LandingView().navigationBarHidden(true),
                    isActive : $viewModel.signOutConfirm
                ) { }
            )
        }
    }
}
