//
//  BoardView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage

struct BoardView : View {
    @StateObject private var viewModel : BoardViewModel
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
//        print("test message" + String(viewModel.totalPostList[0].boardPostInfo.postId))
    }
    
    var body : some View {
        VStack(spacing: 0) {
            
            //Hot Posts
            List {
                Section(header: Text("Hot board")) {
                    ForEach(viewModel.hotLists, id : \.self) { HotList in
                    NavigationLink(
                        destination:
                            PostInfoView(viewModel: PostInfoViewModel(
                                            token: viewModel.token,
                                            postId : HotList.postInfo.postId,
                                            isMyPost : (viewModel.memberId == HotList.member?.memberId)))
                    ) {
                        SpecialPost(viewModel : GeneralPostViewModel(postList: HotList))
                    }
                    }
                }
            }.foregroundColor(Color.mainTheme)
            .listStyle(PlainListStyle()) // iOS 15 대응
            .frame(height:UIScreen.main.bounds.height * 1/6 )
            
            //WantU Posts
            List {
                Section(header: Text("Want U")) {
                    ForEach(viewModel.wantLists, id : \.self) { WantList in
                    NavigationLink(
                        destination:
                            WantUInfoView(viewModel: WantUInfoViewModel(
                                            token: viewModel.token,
                                            postId : WantList.postInfo.postId,
                                            isMyPost : (viewModel.memberId == WantList.member?.memberId)))
                    ) {
                        WantUPost(viewModel : WantUViewModel(postList: WantList))
                    }
                    }
                }
            }.foregroundColor(Color.mainTheme)
            .listStyle(PlainListStyle()) // iOS 15 대응
            .frame(height:UIScreen.main.bounds.height * 1/6 )
            
            Divider()
            
            //General Posts
            List {
                ForEach(viewModel.postLists, id : \.self) { PostList in
                    NavigationLink(
                        destination:
                            PostInfoView(viewModel: PostInfoViewModel(
                                            token: viewModel.token,
                                            postId : PostList.postInfo.postId,
                                            isMyPost : (viewModel.memberId == PostList.member?.memberId)))
                    ) {
                        GeneralPost(viewModel : GeneralPostViewModel(postList: PostList))
                    }
                }
            }.listStyle(PlainListStyle()) // iOS 15 대응
        }.onAppear {
            viewModel.getBoardPosts(token: viewModel.token)
        }
    }
}


struct GeneralPost : View {
    private let viewModel : GeneralPostViewModel
    
    init(viewModel : GeneralPostViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack(spacing: 5) {
            HStack(alignment: .firstTextBaseline){
                URLImage( //프로필 이미지
                    URL(string : viewModel.profileImage) ??
                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width : 40,
                       height: 40)
                .cornerRadius(20)
                
                Group{
                    Text(viewModel.userName)
                        .font(.system(size: 20, weight : .medium))
                        
                    Text(viewModel.createdAt)
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(.black)
            
            URLImage(
                URL(string : viewModel.imageUrl) ??
                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width : UIScreen.main.bounds.width * 0.83,
                   height: UIScreen.main.bounds.height * 0.15)
            .cornerRadius(10)
            
            HStack(alignment: .top){
                Text(viewModel.postTitle)
                    .font(.system(size: 15, weight : .medium))
                
                Spacer()
                
                Image(systemName: "message.fill")
                    .font(.system(size: 10, weight : .medium))
                Text(String(viewModel.commentCount))
                    .font(.system(size: 10, weight : .medium))
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 10, weight : .medium))
                Text(String(viewModel.likeCount))
                    .font(.system(size: 10, weight : .medium))
            }.foregroundColor(.black)
        }
        .modifier(GeneralPostStyle())
    }
}

struct WantUPost : View {
    private let viewModel : WantUViewModel
    
    init(viewModel : WantUViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack(alignment: .leading) {
                Text(viewModel.postTitle)
                    .font(.system(size: 15, weight : .medium))
            
                HStack{
                    Group{
                        Image(systemName: "message.fill")
                            .font(.system(size: 10))
                        Text(String(viewModel.commentCount))
                            .font(.system(size: 10, weight : .medium))
                    }
                    
                    Group{
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 10))
                        Text(String(viewModel.likeCount))
                            .font(.system(size: 10, weight : .medium))
                    }
                }.foregroundColor(.black)
            }
        .modifier(SpecialPostStyle())
    }
}

struct SpecialPost : View {
    private let viewModel : GeneralPostViewModel
    
    init(viewModel : GeneralPostViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack(spacing: 5) {
            HStack(alignment: .top){
                Text(viewModel.postTitle)
                    .font(.system(size: 10, weight : .medium))
                
                Spacer()
                
                Image(systemName: "message.fill")
                    .font(.system(size: 5, weight : .medium))
                Text(String(viewModel.commentCount))
                    .font(.system(size: 5, weight : .medium))
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 5, weight : .medium))
                Text(String(viewModel.likeCount))
                    .font(.system(size: 5, weight : .medium))
            }.foregroundColor(.black)
        }
        .modifier(SpecialPostStyle())
    }
}

