//
//  PostInfoView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import SwiftUI
import URLImage

struct PostInfoView: View { // 게시글 상세 페이지
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : PostInfoViewModel
    @State var isLinkActive : Bool = false
    
    init(viewModel : PostInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                //Profile
                HStack{
                    URLImage( //프로필 이미지
                        URL(string : viewModel.totalBoardPostDetail?.member?.profileImg ?? "https://static.thenounproject.com/png/741653-200.png") ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width : 40,
                           height: 40)
                    .cornerRadius(20)
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(viewModel.totalBoardPostDetail?.member?.username ?? "Anonymous")
                                .fontWeight(.bold)
                            Text(viewModel.totalBoardPostDetail?.boardPostDetail.createdAt ?? "time not found")
                        }
                        Spacer()
                        Button {
                            //수정, 삭제
                        } label : {
                            Image(systemName : "ellipsis")
                                .foregroundColor(.black)
                                .font(.system(size : 15, weight : .bold))
                                .padding()
                        }
                        
                    }
                    
                }
                .padding(.top)
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                
                //Images
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(viewModel.totalBoardPostDetail?.boardPostDetail.postImages ?? [], id : \.self) { imageInfo in
                            URLImage(
                                URL(string : imageInfo.image) ??
                                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                            ) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
                        }
                    }
                }
                
                //Contents
                VStack(alignment: .leading){
                    Text(viewModel.totalBoardPostDetail?.boardPostDetail.title ?? "Title not found")
                        .font(.title2)
                        .fontWeight(.bold)
                
                    
                    HStack(alignment: .lastTextBaseline){
                        Text(viewModel.totalBoardPostDetail?.boardPostDetail.description ?? "No description")
                            .padding()
                        Button{
                            //라이크 버튼 클릭
                            viewModel.isLiked?.toggle()
                            viewModel.likePost(isliked: (viewModel.totalBoardPostDetail?.boardPostDetail.like ?? true))
                        } label : {
                            Image(systemName: (viewModel.isLiked ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .foregroundColor(.black)
                        }
                        Text(String((viewModel.totalBoardPostDetail?.boardPostDetail.likeCount)!) )
                    }
                }
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
                
                Divider()
                
                
                //Comments Area
                Text("Comments")
                    .fontWeight(.bold)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.commentLists, id : \.self) { Comment in
                            CommentView(viewModel : CommentViewModel(commentList: Comment))
                        
                    }
                }.listStyle(PlainListStyle()) // iOS 15 대응
//                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
                
                Divider()
                
                //Comment Input Area
                HStack{
                    TextField("Comment", text: $viewModel.commentInput)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                    Spacer()
                    Button{
                        viewModel.isAnonymous.toggle()
                    } label : {
                        Image(systemName: (viewModel.isAnonymous) ? "checkmark.square.fill" : "checkmark.square")
                            .foregroundColor(.black)
                    }
                    Text("Anonymous")
                    Button{
                        viewModel.sendComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                    } label : {
                        Image(systemName: "paperplane")
                            .foregroundColor(.black)
                    }
                }
                .padding()
                
                
            }.blur(radius: viewModel.isMemberInfoClicked ? 5 : 0)
            .onTapGesture {
                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading : Button {
            self.presentationMode.wrappedValue.dismiss()
        } label : {
            Image(systemName : "chevron.backward")
                .foregroundColor(.mainTheme)
                .font(.system(size : 15, weight : .bold))
        })
    }
}

struct CommentView : View {
    private let viewModel : CommentViewModel
    
    init(viewModel : CommentViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack{
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
            
            Text(viewModel.content)
            Divider()
        }
        .modifier(CommentStyle())
    }
}

