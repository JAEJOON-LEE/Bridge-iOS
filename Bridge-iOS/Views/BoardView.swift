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
    }
    
    var body : some View {
        VStack {
            List {
            
            //Hot Posts
            HStack{
                Text("Hot")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
//                    viewModel.getPosts(token: viewModel.token)
                } label : {
                    Text("MORE")
                }
            }.foregroundColor(.mainTheme)
            .padding(.vertical, 10)
            .frame(height: UIScreen.main.bounds.height * 0.06)
            
//            List {
                    ForEach(viewModel.hotLists, id : \.self) { HotList in
                    NavigationLink(
                        destination:
                            PostInfoView(viewModel: PostInfoViewModel(
                                            token: viewModel.token,
                                            postId : HotList.postInfo.postId,
                                            memberId : viewModel.memberId,
                                            isMyPost : (viewModel.memberId == HotList.member?.memberId)))
                    ) {
                        HotPost(viewModel : GeneralPostViewModel(postList: HotList))
                        }
                    }
//            }
            .foregroundColor(Color.mainTheme)
            .listStyle(PlainListStyle()) // iOS 15 대응
            .frame(height:UIScreen.main.bounds.height * 1/7 )
            
            //Secret Posts
            HStack{
                Text("Secret")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
//                    viewModel.getPosts(token: viewModel.token)
                } label : {
                    Text("MORE")
                }
            }.foregroundColor(.mainTheme)
            .padding(.vertical, 10)
            .frame(height: UIScreen.main.bounds.height * 0.06)
            
//            List {
                ForEach(viewModel.secretLists, id : \.self) { SecretList in
                    NavigationLink(
                        destination:
                            SecretInfoView(viewModel: SecretInfoViewModel(
                                            token: viewModel.token,
                                            postId : SecretList.postInfo.postId,
                                            memberId : viewModel.memberId,
                                            isMyPost : (viewModel.memberId == SecretList.member?.memberId)))
                    ) {
                        SecretPost(viewModel : SecretViewModel(postList: SecretList))
                    }
                }
//            }
            .foregroundColor(Color.mainTheme)
            .listStyle(PlainListStyle()) // iOS 15 대응
            .frame(height:UIScreen.main.bounds.height * 1/7 )
            
            //General Posts
//            List {
                ForEach(viewModel.postLists, id : \.self) { PostList in
                    NavigationLink(
                        destination:
                            PostInfoView(viewModel: PostInfoViewModel(
                                            token: viewModel.token,
                                            postId : PostList.postInfo.postId,
                                            memberId : viewModel.memberId,
                                            isMyPost : (viewModel.memberId == PostList.member?.memberId)))
                    ) {
                        GeneralPost(viewModel : GeneralPostViewModel(postList: PostList))
                    }
//                    .buttonStyle(PlainButtonStyle())
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
        VStack{
            HStack{
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
                
                VStack{
                    Text(viewModel.userName)
                        .font(.system(size: 20, weight : .medium))
                    
                    //Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
                    Text(viewModel.convertReturnedDateString(viewModel.createdAt))
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(.black)
            .padding(.bottom)
            
            if(viewModel.imageUrl != "null"){
                URLImage(
                    URL(string : viewModel.imageUrl!) ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width : UIScreen.main.bounds.width * 0.83,
                       height: UIScreen.main.bounds.height * 0.15)
                .cornerRadius(10)
            }
            
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text(viewModel.postTitle)
                        .font(.system(size: 17, weight : .medium))
                    
                    if(viewModel.imageUrl == "null"){
                        Text(viewModel.description)
                            .font(.system(size: 13))
                    }
                }
                
                Spacer()
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 10, weight : .medium))
                    .foregroundColor(.mainTheme)
                Text(String(viewModel.likeCount))
                    .font(.system(size: 10, weight : .medium))
                
                Image(systemName: "message.fill")
                    .font(.system(size: 10, weight : .medium))
                Text(String(viewModel.commentCount))
                    .font(.system(size: 10, weight : .medium))
            }.foregroundColor(.black)
        }
        .modifier(GeneralPostStyle())
//        .frame(height: viewModel.imageUrl != "null" ? UIScreen.main.bounds.height * 0.27 : UIScreen.main.bounds.height * 0.18)
    }
}

struct SecretPost : View {
    private let viewModel : SecretViewModel
    
    init(viewModel : SecretViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack{
                Text(viewModel.postTitle)
                    .font(.system(size: 15, weight : .medium))
            
                HStack{
                    Group{
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.mainTheme)
                        Text(String(viewModel.likeCount))
                            .font(.system(size: 10, weight : .medium))
                            .foregroundColor(.black)
                    }
                    
                    Group{
                        Image(systemName: "message.fill")
                            .font(.system(size: 10))
                        Text(String(viewModel.commentCount))
                            .font(.system(size: 10, weight : .medium))
                    }.foregroundColor(.black)
                }
            }
        .modifier(SpecialPostStyle())
    }
}

struct HotPost : View {
    private let viewModel : GeneralPostViewModel
    
    init(viewModel : GeneralPostViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack{
                Text(viewModel.postTitle)
                    .font(.system(size: 15, weight : .medium))
            
                HStack{
                    Group{
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.mainTheme)
                        Text(String(viewModel.likeCount))
                            .font(.system(size: 10, weight : .medium))
                            .foregroundColor(.black)
                    }
                    
                    Group{
                        Image(systemName: "message.fill")
                            .font(.system(size: 10))
                        Text(String(viewModel.commentCount))
                            .font(.system(size: 10, weight : .medium))
                    }.foregroundColor(.black)
                }
            }
        .modifier(SpecialPostStyle())
    }
}

