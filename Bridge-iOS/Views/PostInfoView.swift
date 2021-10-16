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
//    @StateObject private var commentViewModel : CommentViewModel
    @State var isLinkActive : Bool = false
    
    init(viewModel : PostInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
//        self._commentViewModel = StateObject(wrappedValue: commentViewModel)
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
                            Text(viewModel.totalBoardPostDetail?.boardPostDetail.createdAt ?? "2021-10-01 00:00:00")
                        }
                        Spacer()
                        
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
                        HStack{
                        CommentView(viewModel : CommentViewModel(token: viewModel.token,
                                                                 commentList: Comment,
                                                                 postId : (viewModel.totalBoardPostDetail?.boardPostDetail.postId)!,
                                                                 commentId : Comment.commentId,
                                                                 isMyComment: viewModel.memberId == Comment.member?.memberId))
                        Button {
                            withAnimation {
                                viewModel.isMenuClicked = true
                                viewModel.showAction = true
                                viewModel.isMyComment = true
                                viewModel.commentId = Comment.commentId
                            }
                            //menu toggle
                        } label: {
                            if viewModel.memberId == Comment.member?.memberId {
                                Image(systemName : "ellipsis")
                                    .foregroundColor(.black)
                                    .font(.system(size : 15, weight : .bold))
                            }
                        }
                        }
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
                
                
            }.onTapGesture {
                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading : Button {
            self.presentationMode.wrappedValue.dismiss()
        } label : {
            Image(systemName : "chevron.backward")
                .foregroundColor(.mainTheme)
                .font(.system(size : 15, weight : .bold))
        },
            trailing:
                Button {
                    withAnimation {
                        viewModel.isMenuClicked = true
                        viewModel.showAction = true
                    }
                    //menu toggle
                } label: {
                    if viewModel.isMyPost {
                        Image(systemName : "ellipsis")
                            .foregroundColor(.black)
                            .font(.system(size : 15, weight : .bold))
                    }
                })
        
        .actionSheet(isPresented: $viewModel.showAction) {
            ActionSheet(
                title: (viewModel.isMyComment) ? Text("Comment Options") : Text("Post Options"),
                buttons: [
                    .default((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")) { viewModel.showPostModify = true },
                    .destructive((viewModel.isMyComment) ? Text("Delete Comment") : Text("Delete Post")) { viewModel.showConfirmDeletion = true },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $viewModel.showConfirmDeletion) {
            Alert(
                title: Text("Confirmation"),
                message: Text((viewModel.isMyComment) ? "Do you want to delete this comment?" : "Do you want to delete this post?"),
                primaryButton: .destructive(Text("Yes"), action : {
                    (viewModel.isMyComment) ? viewModel.deleteComment() : viewModel.deletePost()
                    self.presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("No")))
        }
        .background(
            NavigationLink(
                destination :
                    WritingView(viewModel: WritingViewModel(accessToken: viewModel.token,
                                                            postId : viewModel.postId,
                                                            isForModifying: true,
                                                            isForWantModifying : false))
                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
                isActive : $viewModel.showPostModify) { }
        )
    }
}

struct CommentView : View {
    @StateObject private var viewModel : CommentViewModel
    
//    init(viewModel : CommentViewModel) {
//        self.viewModel = viewModel
//    }
    init(viewModel : CommentViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                
                VStack{
                    Text(viewModel.userName)
                        .font(.system(size: 20, weight : .medium))
                    
                    Text(viewModel.createdAt ?? "2021-10-01 00:00:00")
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

