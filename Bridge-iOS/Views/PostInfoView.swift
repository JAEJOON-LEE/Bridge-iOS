//
//  PostInfoView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import SwiftUI
import URLImage

//viewmodel 수정필요...
var isCocCliked : Bool = false
var commentId : Int = 0
var memberId : Int?
var cocMenuClicked = false
var cocShowAction = false
var contentForViewing : String = "Say something..."
var contentForPatch : String = ""

//@available(iOS 15.0, *)
struct PostInfoView: View { // 게시글 상세 페이지
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : PostInfoViewModel
    @State var isLinkActive : Bool = false
//    @FocusState private var focusField: Field?
//    enum Field: Hashable {
//        case commentfield
//      } //대댓글 버튼 클릭 시, textfield로 focus //ios 15에서
    
    init(viewModel : PostInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        //        self._commentViewModel = StateObject(wrappedValue: commentViewModel)
//        memberId = viewModel.totalBoardPostDetail!.member?.memberId!
    }
    
    var body: some View {
        ZStack {
            VStack {
                //Profile
                HStack{
                    URLImage( //프로필 이미지
                        URL(string : viewModel.totalBoardPostDetail?.member?.profileImage! ?? "https://static.thenounproject.com/png/741653-200.png" ) ?? URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width : 40,
                           height: 40)
                    .cornerRadius(13)
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(viewModel.totalBoardPostDetail?.member?.username! ?? "Anonymous")
                                .fontWeight(.bold)
                            
                            Text(viewModel.convertReturnedDateString(viewModel.totalBoardPostDetail?.boardPostDetail.createdAt ?? "2021-10-01 00:00:00"))
                        }
                        Spacer()
                    }
                }
                .padding()
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                
                ScrollView(.vertical, showsIndicators: false) {
                    //Images
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(viewModel.totalBoardPostDetail?.boardPostDetail.postImages! ?? [], id : \.self) { imageInfo in
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
                        
                        
                        HStack{
                            Text(viewModel.totalBoardPostDetail?.boardPostDetail.description ?? "No description")
                        }
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment : .leading)
                    
                    VStack(alignment: .trailing){
                        HStack{
                            Spacer()
                            
                            Button{
                                //라이크 버튼 클릭
                                viewModel.isLiked?.toggle()
                                viewModel.likePost(isliked: (viewModel.totalBoardPostDetail?.boardPostDetail.like ?? true))
                            } label : {
                                Image(systemName: (viewModel.isLiked ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                    .foregroundColor(.mainTheme)
                            }
                            Text(String((viewModel.totalBoardPostDetail?.boardPostDetail.likeCount ?? 0)) )
                        }
                        .padding()
                    }
                    Divider()
                    
                    
                    //Comments Area
                    VStack{
                        Text("Comment")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.03, alignment : .leading)
                    
                    VStack(alignment: .leading){
                        ForEach(viewModel.commentLists, id : \.self) { Comment in
                            
                            HStack{
                                CommentView(viewModel : CommentViewModel(token: viewModel.token,
                                                                         commentList: Comment,
                                                                         postId : (viewModel.totalBoardPostDetail?.boardPostDetail.postId)!,
                                                                         commentId : Comment.commentId,
                                                                         isMyComment: viewModel.memberId == Comment.member?.memberId))
                                    .overlay(
                                        
                                        Button { // menu button
                                            withAnimation {
                                                viewModel.isMenuClicked = true
                                                viewModel.showAction = true
                                                viewModel.isMyComment = true
                                                viewModel.commentId = Comment.commentId
                                                contentForPatch = Comment.content
                                            }
                                            //menu toggle
                                        } label: {
                                            if viewModel.memberId == Comment.member?.memberId {
                                                Image(systemName : "ellipsis")
                                                    .foregroundColor(.black)
                                                    .font(.system(size : 15, weight : .bold))
                                            }
                                        }
                                        , alignment : .topTrailing
                                    )
                            }
                        }
                    }.listStyle(PlainListStyle()) // iOS 15 대응
                }
                Divider()
                
                //Comment Input Area
                HStack{
                    TextField(contentForViewing, text: $viewModel.commentInput)
//                        .focused($focusField, equals: .commentfield)
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
                        if(isCocCliked){
                            viewModel.sendCommentOfComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous), cocId: commentId)
                            contentForViewing = "Say something..."
                        }
                        else if(contentForPatch.count != 0){
                            viewModel.patchComment(content: viewModel.commentInput)
                            contentForPatch = ""
                            contentForViewing = "Say something..."
                        }
                        else{
                            viewModel.sendComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                            contentForViewing = "Say something..."
                        }
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Post")
                    .foregroundColor(.black)
                    .font(.system(size : 15, weight : .bold))
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading : Button {
                self.presentationMode.wrappedValue.dismiss()
            } label : {
                Image(systemName : "chevron.backward")
                    .foregroundColor(.black)
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
                }
        )
        .actionSheet(isPresented: $viewModel.showAction) {
            ActionSheet(
                title: (viewModel.isMyComment) ? Text("Comment Options") : Text("Post Options"),
                buttons: [
                    .default((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")){
                        if(viewModel.isMyComment){
                            viewModel.showCommentModify = true
                            contentForViewing = contentForPatch
                        }
                        else{
                            viewModel.showPostModify = true
                        }
                    },
                    .destructive((viewModel.isMyComment) ? Text("Delete Comment") : Text("Delete Post")) { viewModel.showConfirmDeletion = true },
                    .cancel()
                ]
            )
        }
//        .actionSheet(isPresented: $viewModel.showAction) {
//            ActionSheet(
//                title: Text("options"),
//                buttons: [
//                    .default( Text("modify comment") ){
////                        viewModel.showPostModify = true
//                    },
//                    .destructive( Text("Delete Comment") ) {
////                        viewModel.showConfirmDeletion = true
//                    },
//                    .cancel()
//                ]
//            )
//        }
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
                                                            isForSecretModifying : false))
                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
                isActive : $viewModel.showPostModify) { }
        )
    }
}

struct CommentView : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var signInViewModel : SignInViewModel
    @StateObject private var viewModel : CommentViewModel
    
    //    init(viewModel : CommentViewModel) {
    //        self.viewModel = viewModel
    //    }
    
    init(viewModel : CommentViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack(alignment: .leading){
            
            HStack{
                URLImage( //프로필 이미지
                    URL(string : viewModel.profileImage)!
//                    URL(string : viewModel.commentList.member!.profileImage!)!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width : 40,
                       height: 40)
                .cornerRadius(13)
                
                VStack(alignment: .leading){
                    Group{
                        Text(viewModel.userName)
                            .font(.system(size: 20, weight : .medium))
                        
                        Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.top, -20)
            
            Text(viewModel.content)
                .padding(.leading, 50)
            
            HStack{
                Spacer()
                
                Button{
                    //댓글 라이크 버튼 클릭
                    viewModel.isLiked?.toggle()
                    viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
                } label : {
                    Image(systemName: (viewModel.commentList.like ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(.mainTheme)
                }
                Text(String((viewModel.commentList.likeCount)))
                    .padding(.trailing)
                
                Button{
                    //대댓글 클릭
                    isCocCliked = true
                    commentId = viewModel.commentId
                    contentForViewing = "@" + viewModel.userName
                    //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
                } label : {
                    Image(systemName: "message.fill")
                        .foregroundColor(.black)
                }
            }
            .font(.system(size: 13))
            
            // 내용들 묶어서 리팩토링 필요
            if(viewModel.commentList.comments.count != 0){
                               //여기 대댓글
                    ForEach(viewModel.commentList.comments, id : \.self) { CommentofComment in
                        HStack{
                            Spacer()
                        VStack(alignment: .leading){
                            
                            HStack{
                                
                                
                                URLImage( //프로필 이미지
                                    URL(string : CommentofComment.member!.profileImage!)!
                                ) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(width : 30,
                                       height: 30)
                                .cornerRadius(9)
                                
                                VStack(alignment: .leading){
                                    Group{
                                        Text(CommentofComment.member!.username! ?? "Anonymous")
                                            .font(.system(size: 15, weight : .medium))
                                        
                                        Text(viewModel.convertReturnedDateString(CommentofComment.createdAt ?? "2021-10-01 00:00:00"))
                                            .font(.system(size: 11))
                                    }
                                    .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .frame(alignment: .leading)
                            
                            Text(CommentofComment.content)
                                .padding(.leading, 40)
                            
                            HStack{
                                Spacer()
                                
                                Button{
                                    //댓글 라이크 버튼 클릭
                                    viewModel.isLiked?.toggle()
                                    viewModel.likeCommentOfComment(isliked: CommentofComment.like ?? true, cocId : CommentofComment.commentId)
                                } label : {
                                    Image(systemName: (CommentofComment.like ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .foregroundColor(.mainTheme)
                                }
                                Text(String((CommentofComment.likeCount)))
                                    .padding(.trailing)
                                
                                Button{
                                    //대댓글의 대댓글 없다고 했지..?
                                    //                            viewModel.isLiked?.toggle()
                                    //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
                                } label : {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(alignment: .trailing)
                        }
                        .font(.system(size: 11))
                        .padding()
                        .frame(width : 250, alignment: .trailing)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(20)
                            
                        }
//                        Divider()
//                            .frame(width : 200, alignment: .trailing)
                    }.overlay(
                        
                        Button { // menu button
                            withAnimation {
                                cocShowAction = true
                                cocMenuClicked = true
                            }
                            //menu toggle
                        } label: { //signInViewModel.signInResponse!.memberId == CommentOfComment.member!.memberId!
//                            if (signInViewModel.signInResponse!.memberId == viewModel.commentList.member?.memberId!) {
//                            if(memberId == viewModel.commentList.member?.memberId!){
                                Image(systemName : "ellipsis")
                                    .foregroundColor(.black)
                                    .font(.system(size : 15, weight : .bold))
                                    .padding(15)
                            }
//                        }
                        , alignment : .topTrailing
                    )
                    .frame(alignment: .trailing)
            }
            
            Divider()
        }
        .modifier(CommentStyle())
        
//        .actionSheet(isPresented: $viewModel.showAction) {
//            ActionSheet(
//                title: Text("options"),
//                buttons: [
//                    .default( Text("modify comment") ){
////                        viewModel.showPostModify = true
//                    },
//                    .destructive( Text("Delete Comment") ) {
////                        viewModel.showConfirmDeletion = true
//                    },
//                    .cancel()
//                ]
//            )
//        }
    }
}
