//
//  WantUInfoView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/11.
//

import SwiftUI
import URLImage

struct WantUInfoView: View { // 게시글 상세 페이지
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : WantUInfoViewModel
    @State var isLinkActive : Bool = false
    
    init(viewModel : WantUInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                //Profile
                HStack{
                    URLImage( //프로필 이미지
                        URL(string : viewModel.totalWantPostDetail?.member?.profileImg ?? "https://static.thenounproject.com/png/741653-200.png") ??
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
                            Text(viewModel.totalWantPostDetail?.member?.username ?? "Anonymous")
                                .fontWeight(.bold)
                            Text(viewModel.totalWantPostDetail?.wantPostDetail.createdAt ?? "time not found")
                        }
                        Spacer()
                    }
                    
                }
                .padding(.top)
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                
                //Images
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(viewModel.totalWantPostDetail?.wantPostDetail.postImages ?? [], id : \.self) { imageInfo in
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
                    Text(viewModel.totalWantPostDetail?.wantPostDetail.title ?? "Title not found")
                        .font(.title2)
                        .fontWeight(.bold)
                
                    
                    HStack(alignment: .lastTextBaseline){
                        Text(viewModel.totalWantPostDetail?.wantPostDetail.description ?? "No description")
                            .padding()
                        Button{
                            //라이크 버튼 클릭
                            viewModel.isLiked?.toggle()
                            viewModel.likeWantPost(isliked: (viewModel.totalWantPostDetail?.wantPostDetail.like ?? true))
                        } label : {
                            Image(systemName: (viewModel.isLiked ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .foregroundColor(.black)
                        }
                        Text(String((viewModel.totalWantPostDetail?.wantPostDetail.likeCount)!) )
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
                                                                     postId : (viewModel.totalWantPostDetail?.wantPostDetail.postId)!,
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
                        viewModel.sendWantComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
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
                    (viewModel.isMyComment) ? viewModel.deleteWantComment() : viewModel.deleteWantPost()
                    self.presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("No")))
        }
        .background(
            NavigationLink(
                destination :
                    WritingView(viewModel: WritingViewModel(accessToken: viewModel.token,
                                                            postId : (viewModel.totalWantPostDetail?.wantPostDetail.postId)!,
                                                            isForModifying: true,
                                                            isForWantModifying: true))
                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
                isActive : $viewModel.showPostModify) { }
        )

    }
}

struct WantCommentView : View {
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

