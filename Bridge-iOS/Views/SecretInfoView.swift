////
////  SecretInfoView.swift
////  Bridge-iOS
////
////  Created by 이재준 on 2021/10/11.
////
//
//import SwiftUI
//import URLImage
//
////
////  PostInfoView.swift
////  Bridge-iOS
////
////  Created by 이재준 on 2021/10/08.
////
//
//import SwiftUI
//import URLImage
//
////@available(iOS 15.0, *)
//struct SecretInfoView : View { // 게시글 상세 페이지
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var viewModel : SecretInfoViewModel
//    @State var isLinkActive : Bool = false
//    //    @FocusState private var focusField: Field?
//    //    enum Field: Hashable {
//    //        case commentfield
//    //      } //대댓글 버튼 클릭 시, textfield로 focus //ios 15에서
//    
//    init(viewModel : SecretInfoViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//
//    
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                //Profile
//                HStack{
//                    //                    if(viewModel.isSecret == false){
//                    
//                    Button{
//                        viewModel.isMemberInfoClicked.toggle()
//                    } label : {
//                        URLImage( //프로필 이미지
//                            URL(string : viewModel.totalSecretPostDetail?.member?.profileImage! ?? "https://static.thenounproject.com/png/741653-200.png" ) ?? URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                        ) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                        }
//                        .frame(width : 40,
//                               height: 40)
//                        .cornerRadius(13)
//                    }
//                    //                    }
//                    
//                    HStack{
//                        VStack(alignment: .leading){
//                                Text("Anonymous")
//                                    .fontWeight(.bold)
//                                
//                                Text(viewModel.convertReturnedDateString(viewModel.totalSecretPostDetail?.secretPostDetail.createdAt ?? "2021-10-01 00:00:00"))
//                        }
//                        Spacer()
//                    }
//                }
//                .padding()
//                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
//                
//                ScrollView(.vertical, showsIndicators: false) {
//                    //Images
//                    ScrollView(.horizontal, showsIndicators: true) {
//                        HStack {
//                            
//                                ForEach(viewModel.totalSecretPostDetail?.secretPostDetail.postImages! ?? [], id : \.self) { imageInfo in
//                                    URLImage(
//                                        URL(string : imageInfo.image) ??
//                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                                    ) { image in
//                                        image
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width : viewModel.totalSecretPostDetail?.secretPostDetail.postImages! .count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: UIScreen.main.bounds.height * 0.23)
//                                            .cornerRadius(10)
//                                            .padding(.horizontal)
//                                    }
//                                    .frame(width : viewModel.totalSecretPostDetail?.secretPostDetail.postImages! .count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: UIScreen.main.bounds.height * 0.23)
//                                }
//                            
//                        }
//                        .padding()
//                    }
//                    
//                    //Contents
//                    VStack(alignment: .leading){
//                        
//                            Text(viewModel.totalSecretPostDetail?.secretPostDetail.title ?? "Title not found")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            
//                            HStack{
//                                Text(viewModel.totalSecretPostDetail?.secretPostDetail.description ?? "No description")
//                            }
//                        
//                    }
//                    .padding(.leading)
//                    .padding(.bottom)
//                    .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1, alignment : .leading)
//                    
//                    VStack(alignment: .trailing){
//                        HStack{
//                            Spacer()
//                            
//                            Button{
//                                //라이크 버튼 클릭
//                                viewModel.isLiked?.toggle()
//                                
//                                    viewModel.likeSecretPost(isliked: (viewModel.totalSecretPostDetail?.secretPostDetail.like ?? true))
//                                    viewModel.getSecretPostDetail()
//                                
//                            } label : {
//                                Image((viewModel.isLiked ?? true) ? "like" : "like_border")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(.mainTheme)
//                            }
//                                Text(String((viewModel.totalSecretPostDetail?.secretPostDetail.likeCount ?? 0)) )
//                            
//                        }
//                        .padding()
//                    }
//                    Divider()
//                    
//                    //Comments Area
//                    VStack{
//                        Text("Comment")
//                            .fontWeight(.bold)
//                    }
//                    .padding()
//                    .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.03, alignment : .leading)
//                    
//                    VStack(alignment: .leading){
//                        commentView
//                    }.listStyle(PlainListStyle()) // iOS 15 대응
//                }
//                Divider()
//                
//                //Comment Input Area
//                HStack{
//                    TextField(viewModel.contentForViewing, text: $viewModel.commentInput)
//                    //                        .focused($focusField, equals: .commentfield)
//                        .autocapitalization(.none)
//                        .accentColor(.mainTheme)
//                    
//                    Spacer()
//                    
//                    HStack {
//                        Text("Anonymous").foregroundColor(.gray)
//                        Button {
//                            viewModel.isAnonymous.toggle()
//                        } label : {
//                            Image(systemName: !viewModel.isAnonymous ? "square" : "checkmark.square.fill")
//                                .foregroundColor(!viewModel.isAnonymous ? .gray : .mainTheme)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Button{
//                        if(viewModel.isCocCliked){
//                                viewModel.sendSecretCommentOfComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous), cocId: viewModel.commentId!)
//                                viewModel.contentForViewing = "Say something..."
//                                viewModel.contentForPatch = ""
//                                viewModel.commentInput = ""
//                                viewModel.getSecretPostDetail()
//                                viewModel.getSecretComment()
//                                viewModel.isCocCliked = false
//                            
//                        }
//                        else if(viewModel.showCommentModify == true){
//                                viewModel.patchSecretComment(content: viewModel.commentInput)
//                                viewModel.contentForViewing = "Say something..."
//                                viewModel.contentForPatch = ""
//                                viewModel.commentInput = ""
//                                viewModel.getSecretPostDetail()
//                                viewModel.getSecretComment()
//                            
//                        }
//                        else{
//                                viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
//                                viewModel.contentForViewing = "Say something..."
//                                viewModel.contentForPatch = ""
//                                viewModel.commentInput = ""
//                                viewModel.getSecretPostDetail()
//                                viewModel.getSecretComment()
//                            
//                        }
//                        withAnimation { viewModel.isProgressShow = true }
//                    } label : {
//                        Image(systemName: "paperplane")
//                            .foregroundColor(.black)
//                    }
//                }
//                .padding()
//            }.onTapGesture {
//                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
//            }
//            .blur(radius: viewModel.isMemberInfoClicked ? 3 : 0)
//            
//            if viewModel.isMemberInfoClicked {
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button {
//                            withAnimation { viewModel.isMemberInfoClicked = false }
//                        } label : {
//                            Image(systemName: "xmark.circle")
//                                .font(.system(size : 20, weight : .bold))
//                                .foregroundColor(.white)
//                        }.padding()
//                    }.frame(height: 50)
//                    
//                    URLImage(
//                        URL(string : viewModel.totalBoardPostDetail?.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
//                    ) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    }
//                    .clipShape(Circle())
//                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
//                    .shadow(radius: 5)
//                    
//                    Text(viewModel.totalBoardPostDetail?.member?.username ?? "Unknown UserName")
//                        .font(.system(size : 20, weight : .bold))
//                        .foregroundColor(.white)
//                    Text("\"" + (viewModel.totalBoardPostDetail?.member?.description  ?? "User not found") + "\"")
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                .frame(width : UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 1/3)
//                .background(Color.mainTheme)
//                .cornerRadius(15)
//                .shadow(radius: 5)
//            }
//            
////            if viewModel.isProgressShow {
////                HStack (spacing : 20) {
////                    ProgressView()
////                        .progressViewStyle(CircularProgressViewStyle(tint: Color.mainTheme))
////                    Text("Loading...")
////                        .foregroundColor(.darkGray)
////                }
////                .frame(width : UIScreen.main.bounds.width * 0.6, height : UIScreen.main.bounds.height * 0.15)
////                .cornerRadius(30)
////                .background(Color.white.shadow(radius: 3))
////            }
//        }.onAppear {
//            if(viewModel.isMyPost != nil){
//                viewModel.contentForViewing = "Say something..."
//                viewModel.contentForPatch = ""
//                viewModel.commentInput = ""
//                viewModel.getBoardPostDetail()
//                viewModel.getComment()
//            }else{
////                viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
//                viewModel.contentForViewing = "Say something..."
//                viewModel.contentForPatch = ""
//                viewModel.commentInput = ""
//                viewModel.getSecretPostDetail()
//                viewModel.getSecretComment()
//            }
//        }
//        .onDisappear {
//            if(viewModel.isMyPost != nil){
//                viewModel.contentForViewing = "Say something..."
//                viewModel.contentForPatch = ""
//                viewModel.commentInput = ""
//                viewModel.getBoardPostDetail()
//                viewModel.getComment()
//            }else{
////                viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
//                viewModel.contentForViewing = "Say something..."
//                viewModel.contentForPatch = ""
//                viewModel.commentInput = ""
//                viewModel.getSecretPostDetail()
//                viewModel.getSecretComment()
//            }
//        }
//        .onChange(of: viewModel.commentSended, perform: { _ in
//            
//                if(viewModel.isMyPost != nil){
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getBoardPostDetail()
//                    viewModel.getComment()
//                }else{
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getSecretPostDetail()
//                    viewModel.getSecretComment()
//                }
//        })
//        .onChange(of: viewModel.showConfirmDeletion, perform: { _ in
//            
//                if(viewModel.isMyPost != nil){
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getBoardPostDetail()
//                    viewModel.getComment()
//                }else{
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getSecretPostDetail()
//                    viewModel.getSecretComment()
//                }
//        })
//        .onChange(of: viewModel.showAction, perform: { _ in
//            
//                if(viewModel.isMyPost != nil){
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getBoardPostDetail()
//                    viewModel.getComment()
//                }else{
//                    viewModel.contentForViewing = "Say something..."
//                    viewModel.contentForPatch = ""
//                    viewModel.commentInput = ""
//                    viewModel.getSecretPostDetail()
//                    viewModel.getSecretComment()
//                }
//        }).onChange(of: viewModel.isLiked, perform: { _ in
//            
//            if(viewModel.isSecret == false){
//                viewModel.getBoardPostDetail()
//            }else{
//                viewModel.getSecretPostDetail()
//            }
//    })
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Post")
//                    .foregroundColor(.black)
//                    .font(.system(size : 15, weight : .bold))
//                    .accessibilityAddTraits(.isHeader)
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(
//            leading : Button {
//                self.presentationMode.wrappedValue.dismiss()
//            } label : {
//                Image(systemName : "chevron.backward")
//                    .foregroundColor(.black)
//                    .font(.system(size : 15, weight : .bold))
//            },
//            trailing:
//                Button {
//                    withAnimation {
//                        viewModel.isMenuClicked = true
//                        viewModel.showAction = true
//                    }
//                    //menu toggle
//                } label: {
//                    if ((viewModel.totalSecretPostDetail?.secretPostDetail.modifiable == true)){
//                        Image(systemName : "ellipsis")
//                            .foregroundColor(.black)
//                            .font(.system(size : 15, weight : .bold))
//                    }
//                }
//        )
//        .actionSheet(isPresented: $viewModel.showAction) {
//            ActionSheet(
//                title: (viewModel.isMyComment) ? Text("Comment Options") : Text("Post Options"),
//                buttons: [
//                    .default((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")){
//                        if(viewModel.isMyComment){
//                            viewModel.showCommentModify = true
//                            viewModel.contentForViewing = viewModel.contentForPatch
//                        }
//                        else{
//                            viewModel.showPostModify = true
//                        }
//                    },
//                    .destructive((viewModel.isMyComment) ? Text("Delete Comment") : Text("Delete Post")) {
//                        viewModel.showConfirmDeletion = true
//                        
//                    },
//                    .cancel()
//                ]
//            )
//        }
////        .actionSheet(isPresented: $viewModel.showAction) {
////            ActionSheet(
////                title: Text("options"),
////                buttons: [
////                    .default( Text("modify comment") ){
////                        //                        viewModel.showPostModify = true
////                    },
////                    .destructive( Text("Delete Comment") ) {
////                        //                        viewModel.showConfirmDeletion = true
////                    },
////                    .cancel()
////                ]
////            )
////        }
//        .alert(isPresented: $viewModel.showConfirmDeletion) {
//            Alert(
//                title: Text("Confirmation"),
//                message: Text((viewModel.isMyComment) ? "Do you want to delete this comment?" : "Do you want to delete this post?"),
//                primaryButton: .destructive(Text("Yes"), action : {
//                    if(viewModel.isSecret == false){
//                        if(viewModel.isMyComment){
//                            viewModel.deleteComment()
//                            viewModel.getBoardPostDetail()
//                            viewModel.getComment()
//                        }
//                        else{
//                            viewModel.deletePost()
//                            self.presentationMode.wrappedValue.dismiss()
//                        }
//                    }else{
//                        if(viewModel.isMyComment){
//                            viewModel.deleteSecretComment()
//                            viewModel.getSecretPostDetail()
//                            viewModel.getSecretComment()
//                        }
//                        else{
//                            viewModel.deleteSecretPost()
//                            self.presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                    
//                }),
//                secondaryButton: .cancel(Text("No")))
//        }
//        .background(
//            NavigationLink(
//                destination :
//                    WritingView(viewModel: WritingViewModel(accessToken: viewModel.token,
//                                                            postId : viewModel.postId,
//                                                            isForModifying: true,
//                                                            isForSecretModifying : false))
//                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
//                isActive : $viewModel.showPostModify) { }
//        )
//    }
//}
//
//extension SecretInfoView {
//    var commentView : some View {
//        ForEach(viewModel.commentLists, id : \.self) { Comment in
//            
//            VStack(alignment: .leading){
//                HStack{
//                    URLImage( //프로필 이미지
//                        URL(string : (Comment.member?.profileImage) ?? "https://static.thenounproject.com/png/741653-200.png") ??
//                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                    ) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    }
//                    .frame(width : 40,
//                           height: 40)
//                    .cornerRadius(13)
//                    
//                    
//                    VStack(alignment: .leading){
//                        Group{
//                            Text(Comment.member?.username ?? "Anonymous" )
//                                .font(.system(size: 20, weight : .medium))
//                            
//                            Text(viewModel.convertReturnedDateString(Comment.createdAt ?? "2021-10-01 00:00:00"))
//                                .font(.system(size: 10))
//                        }
//                        .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                }
//                .padding(.top, -20)
//                
//                Text(Comment.content)
//                    .padding(.leading, 50)
//                
//                HStack{
//                    Spacer()
//                    
//                    Button{
//                        //댓글 라이크 버튼 클릭
//                        viewModel.isLiked?.toggle()
//                        viewModel.likeComment(isliked: Comment.like)
//                    } label : {
////                        Image(Comment.like ? "like" : "like_border")
////                            .font(.system(size: 15))
////                            .foregroundColor(.mainTheme)
//                    }
//                    Text(String((Comment.likeCount)))
//                        .padding(.trailing)
//                    
//                    Button{
//                        //대댓글 클릭
//                        viewModel.isCocCliked = true
//                        viewModel.commentId = Comment.commentId
//                        //                        commentId = viewModel.commentId
//                        viewModel.contentForViewing = "@" + (Comment.member?.username ?? "Anonymous")
//                        //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
//                    } label : {
//                        Image(systemName: "message.fill")
//                            .foregroundColor(.black)
//                    }
//                }
//                .font(.system(size: 13))
//                
//                // 대댓글
//                // 내용들 묶어서 리팩토링 필요
////                if(Comment.comments != nil){
////                    CocView(viewModel : CommentViewModel(token: viewModel.token,
////                                                         commentList: Comment.comments!,
////                                                             postId : (viewModel.totalBoardPostDetail?.boardPostDetail.postId)!,
////                                                             commentId : Comment.commentId,
////                                                             memberId : Comment.member?.memberId ?? -1,
////                                                             isMyComment: viewModel.memberId == Comment.member?.memberId)
////                            )
////                }else{
////                    Spacer()
////                }
//                
////                if(Comment.comments != nil){
//                ForEach(Comment.comments!, id : \.self) { Coc in
//                        
////                        CocView(viewModel : CommentViewModel(token: viewModel.token,
////                                                             commentList: Comment.comments!,
////                                                                 postId : (viewModel.totalBoardPostDetail?.boardPostDetail.postId)!,
////                                                                 commentId : Coc.commentId,
////                                                                 memberId : Coc.member?.memberId ?? -1,
////                                                                 isMyComment: viewModel.memberId == Coc.member?.memberId)
////                                )
//                    HStack{
//                        Spacer()
//                        
//                        VStack(alignment: .leading){
//                            HStack{
//                                URLImage( //프로필 이미지
//                                    URL(string : (Coc.member?.profileImage) ?? "https://static.thenounproject.com/png/741653-200.png") ??
//                                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                                ) { image in
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                }
//                                .frame(width : 30,
//                                       height: 30)
//                                .cornerRadius(9)
//                                
//                                VStack(alignment: .leading){
//                                    
//                                    Text(Coc.member?.username ?? "Anonymous" )
//                                        .font(.system(size: 15, weight : .medium))
//                                    
//                                    Text(viewModel.convertReturnedDateString(Coc.createdAt ?? "2021-10-01 00:00:00"))
//                                        .font(.system(size: 11))
//                                    
//                                }
//                                .foregroundColor(.gray)
//                                
//                                Spacer()
//                            }
//                            .frame(alignment: .leading)
//                            
//                            Text(Coc.content)
//                                .padding(.leading, 40)
//                            
////                            HStack{
////                                Spacer()
////                            }
//                        }
//                        .font(.system(size: 11))
//                        .padding()
//                        .frame(width : 250, alignment: .trailing)
//                        .background(Color.systemDefaultGray)
//                        .cornerRadius(20)
//                        
//                        
//                        
//                        
//                        
//                        
//                        
//                    }
//                    .frame(alignment : .leading)
//                }
////                }
//                    
////                        HStack{
////                            Spacer()
////
////                            VStack(alignment: .leading){
////                                HStack{
////                                    URLImage( //프로필 이미지
////                                        URL(string : (Coc.member?.profileImage) ?? "https://static.thenounproject.com/png/741653-200.png") ??
////                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
////                                    ) { image in
////                                        image
////                                            .resizable()
////                                            .aspectRatio(contentMode: .fill)
////                                    }
////                                    .frame(width : 30,
////                                           height: 30)
////                                    .cornerRadius(9)
////
////                                    VStack(alignment: .leading){
////                                        Group{
////                                            Text(Coc.member?.username ?? "Anonymous")
////                                                .font(.system(size: 15, weight : .medium))
////
//////                                            Text(viewModel.convertReturnedDateString(Coc.createdAt ?? "2021-10-01 00:00:00"))
//////                                                .font(.system(size: 11))
////                                        }
////                                        .foregroundColor(.gray)
////                                    }
////                                    Spacer()
////                                }
////                            }
////                            .frame(alignment : .leading)
////
////
////                        }
////                    }
////            }
////                if(Comment.comments.count != 0){
//                    Divider()
//                }
//                .modifier(CommentStyle())
//                .overlay(
//                    Button { // menu button
//                        withAnimation {
//                            viewModel.isMenuClicked = true
//                            viewModel.showAction = true
//                            viewModel.isMyComment = true
//                            viewModel.commentId = Comment.commentId
//                            viewModel.contentForPatch = Comment.content
//                        }
//                            //menu toggle
//                    } label: {
//                        if viewModel.memberId == Comment.member?.memberId {
//                            Image(systemName : "ellipsis")
//                                .foregroundColor(.black)
//                                .font(.system(size : 15, weight : .bold))
//                        }
//                    }
//                    , alignment : .topTrailing
//                )
//        }
//    }
//}
//
////struct CocView : View {
////    @StateObject private var viewModel : CommentViewModel
////    @EnvironmentObject var postInfoViewModel : PostInfoViewModel
////
////    init(viewModel : CommentViewModel) {
////        self._viewModel = StateObject(wrappedValue: viewModel)
////    }
////
////    var body : some View {
////        Spacer()
////    }
////}
//
////struct CommentView : View {
////    @Environment(\.presentationMode) var presentationMode
//////    @EnvironmentObject var signInViewModel : SignInViewModel
////    @StateObject private var viewModel : CommentViewModel
////    @EnvironmentObject var postInfoViewModel : PostInfoViewModel
////
////    //    init(viewModel : CommentViewModel) {
////    //        self.viewModel = viewModel
////    //    }
////
////    init(viewModel : CommentViewModel) {
////        self._viewModel = StateObject(wrappedValue: viewModel)
////    }
////
////    var body : some View {
////        VStack(alignment: .leading){
////
////            HStack{
////                URLImage( //프로필 이미지
////                    URL(string : viewModel.profileImage)!
//////                    URL(string : viewModel.commentList.member!.profileImage!)!
////                ) { image in
////                    image
////                        .resizable()
////                        .aspectRatio(contentMode: .fill)
////                }
////                .frame(width : 40,
////                       height: 40)
////                .cornerRadius(13)
////
////                VStack(alignment: .leading){
////                    Group{
////                        Text(viewModel.userName)
////                            .font(.system(size: 20, weight : .medium))
////
////                        //Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
////                        Text(viewModel.convertReturnedDateString(viewModel.createdAt))
////                            .font(.system(size: 10))
////                    }
////                    .foregroundColor(.gray)
////                }
////
////                Spacer()
////            }
////            .padding(.top, -20)
////
////            Text(viewModel.content)
////                .padding(.leading, 50)
////
////            HStack{
////                Spacer()
////
////                Button{
////                    //댓글 라이크 버튼 클릭
////                    viewModel.isLiked?.toggle()
////                    //viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
////                    viewModel.likeComment(isliked: viewModel.commentList.like)
////                } label : {
////                    Image(systemName: viewModel.commentList.like ? "hand.thumbsup.fill" : "hand.thumbsup")
////                        .foregroundColor(.mainTheme)
////                }
////                Text(String((viewModel.commentList.likeCount)))
////                    .padding(.trailing)
////
////                Button{
////                    //대댓글 클릭
//////                    isCocCliked = true
//////                    commentId = viewModel.commentId
//////                    contentForViewing = "@" + viewModel.userName
////                    //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
////                } label : {
////                    Image(systemName: "message.fill")
////                        .foregroundColor(.black)
////                }
////            }
////            .font(.system(size: 13))
////
////            // 내용들 묶어서 리팩토링 필요
////            if(viewModel.commentList.comments != nil){
////                          //     여기 대댓글
////                    ForEach(viewModel.commentList.comments!, id : \.self) { CommentofComment in
////                        HStack{
////                            Spacer()
////                        VStack(alignment: .leading){
////
////                            HStack{
////
////
////                                URLImage( //프로필 이미지
////                                    URL(string : CommentofComment.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
////                                ) { image in
////                                    image
////                                        .resizable()
////                                        .aspectRatio(contentMode: .fill)
////                                }
////                                .frame(width : 30,
////                                       height: 30)
////                                .cornerRadius(9)
////
////                                VStack(alignment: .leading){
////                                    Group{
////                                        Text(CommentofComment.member?.username ?? "Anonymous")
////                                            .font(.system(size: 15, weight : .medium))
////
////                                        Text(viewModel.convertReturnedDateString(CommentofComment.createdAt))
////                                            .font(.system(size: 11))
////                                    }
////                                    .foregroundColor(.gray)
////                                }
////                                Spacer()
////                            }
////                            .frame(alignment: .leading)
////
////                            Text(CommentofComment.content)
////                                .padding(.leading, 40)
////
////                            HStack{
////                                Spacer()
////
////                                Button{
////                                    //댓글 라이크 버튼 클릭
////                                    viewModel.isLiked?.toggle()
////                                    viewModel.likeCommentOfComment(isliked: CommentofComment.like, cocId : CommentofComment.commentId)
////                                } label : {
////                                    Image(systemName: CommentofComment.like ? "hand.thumbsup.fill" : "hand.thumbsup")
////                                        .foregroundColor(.mainTheme)
////                                }
////                                Text(String((CommentofComment.likeCount)))
////                                    .padding(.trailing)
////
////                                Button{
////                                    //대댓글의 대댓글 없다고 했지..?
////                                    //                            viewModel.isLiked?.toggle()
////                                    //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
////                                } label : {
////                                    Image(systemName: "message.fill")
////                                        .foregroundColor(.black)
////                                }
////                            }
////                            .frame(alignment: .trailing)
////                        }
////                        .font(.system(size: 11))
////                        .padding()
////                        .frame(width : 250, alignment: .trailing)
////                        .background(Color.systemDefaultGray)
////                        .cornerRadius(20)
////                        .overlay(
////
////                            Button { // menu button
////                                withAnimation {
////
////                                    postInfoViewModel.isMenuClicked = true
////                                    postInfoViewModel.showAction = true
////                                    postInfoViewModel.isMyComment = true
////                                    postInfoViewModel.commentId = CommentofComment.commentId
////                                    postInfoViewModel.contentForPatch = CommentofComment.content
////                                }
////                                //menu toggle
////                            } label: { //signInViewModel.signInResponse!.memberId == CommentOfComment.member!.memberId!
////                                //                                if ((CommentofComment.member?.memberId!)! == viewModel.memberId) {
//////                                if (signInViewModel.signInResponse?.memberId == CommentofComment.member!.memberId!) {
////                                //
////                                if viewModel.memberId == postInfoViewModel.totalBoardPostDetail?.member?.memberId! {
////                                    Image(systemName : "ellipsis")
////                                        .foregroundColor(.black)
////                                        .font(.system(size : 15, weight : .bold))
////                                }
////                            }
////    //                        }
////                            , alignment : .topTrailing
////                        )
////
////                        }
//////                        Divider()
//////                            .frame(width : 200, alignment: .trailing)
////                    }
////                    .frame(alignment: .trailing)
////            }
////
////            Divider()
////
////        }
////        .modifier(CommentStyle())
////
//////        .actionSheet(isPresented: $viewModel.showAction) {
//////            ActionSheet(
//////                title: Text("options"),
//////                buttons: [
//////                    .default( Text("modify comment") ){
////////                        viewModel.showPostModify = true
//////                    },
//////                    .destructive( Text("Delete Comment") ) {
////////                        viewModel.showConfirmDeletion = true
//////                    },
//////                    .cancel()
//////                ]
//////            )
//////        }
////    }
////}
//
//
////struct SecretInfoView: View { // 게시글 상세 페이지
////    @Environment(\.presentationMode) var presentationMode
////    @StateObject private var viewModel : SecretInfoViewModel
////    @State var isLinkActive : Bool = false
////
////    init(viewModel : SecretInfoViewModel) {
////        self._viewModel = StateObject(wrappedValue: viewModel)
////    }
////
////    var body: some View {
////        ZStack {
////            VStack {
////                //Profile
////                HStack{
//////                    URLImage( //프로필 이미지
//////                        URL(string : viewModel.totalSecretPostDetail!.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
//////                    ) { image in
//////                        image
//////                            .resizable()
//////                            .aspectRatio(contentMode: .fill)
//////                    }
//////                    .frame(width : 40,
//////                           height: 40)
//////                    .cornerRadius(20)
////
////                    HStack{
////                        VStack(alignment: .leading){
//////                            Text(viewModel.totalSecretPostDetail!.member?.username ?? "Anonymous")
//////                                .fontWeight(.bold)
////
////                            Text(viewModel.convertReturnedDateString(viewModel.totalSecretPostDetail?.secretPostDetail.createdAt ?? "2021-10-01 00:00:00"))
////                        }
////                        Spacer()
////
////                        Button{
////                            //라이크 버튼 클릭
////                            viewModel.isLiked?.toggle()
////                            viewModel.likeSecretPost(isliked: (viewModel.totalSecretPostDetail?.secretPostDetail.like ?? true))
////                        } label : {
////                            Image(systemName: (viewModel.isLiked ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
////                                .foregroundColor(.mainTheme)
////                        }
////                        Text(String((viewModel.totalSecretPostDetail!.secretPostDetail.likeCount)) )
////                    }
////
////                }
////                .padding()
////                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
////
////                //Images
////                ScrollView(.horizontal, showsIndicators: true) {
////                    HStack {
////                        ForEach(viewModel.totalSecretPostDetail?.secretPostDetail.postImages ?? [], id : \.self) { imageInfo in
////                            URLImage(
////                                URL(string : imageInfo.image) ??
////                                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
////                            ) { image in
////                                image
////                                    .resizable()
////                                    .aspectRatio(contentMode: .fill)
////                            }
////                            .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
////                        }
////                    }
////                }
////
////                //Contents
////                VStack(alignment: .leading){
////                    Text(viewModel.totalSecretPostDetail?.secretPostDetail.title ?? "Title not found")
////                        .font(.title2)
////                        .fontWeight(.bold)
////
////
////                    HStack(alignment: .lastTextBaseline){
////                        Text(viewModel.totalSecretPostDetail?.secretPostDetail.description ?? "No description")
////                            .padding()
////                    }
////                }
////                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
////
////                Divider()
////
////
////                //Comments Area
////                Text("Comments")
////                    .fontWeight(.bold)
////                ScrollView(.vertical, showsIndicators: false) {
////                    ForEach(viewModel.commentLists, id : \.self) { Comment in
//////                        HStack{
//////                            CommentView(viewModel : CommentViewModel(token: viewModel.token,
//////                                                                     commentList: Comment,
//////                                                                     postId : (viewModel.totalSecretPostDetail?.secretPostDetail.postId)!,
//////                                                                     commentId : Comment.commentId,
//////                                                                     isMyComment: viewModel.memberId == Comment.member?.memberId))
//////                        Button {
//////                            withAnimation {
//////                                viewModel.isMenuClicked = true
//////                                viewModel.showAction = true
//////                                viewModel.isMyComment = true
//////                                viewModel.commentId = Comment.commentId
//////                            }
//////                            //menu toggle
//////                        } label: {
//////                            if viewModel.memberId == Comment.member?.memberId {
//////                                Image(systemName : "ellipsis")
//////                                    .foregroundColor(.black)
//////                                    .font(.system(size : 15, weight : .bold))
//////                            }
//////                        }
//////                        }
////                    }
////                }.listStyle(PlainListStyle()) // iOS 15 대응
//////                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
////
////                Divider()
////
////                //Comment Input Area
////                HStack{
////                    TextField("Comment", text: $viewModel.commentInput)
////                        .autocapitalization(.none)
////                        .accentColor(.mainTheme)
////                    Spacer()
////                    Button{
////                        viewModel.isAnonymous.toggle()
////                    } label : {
////                        Image(systemName: (viewModel.isAnonymous) ? "checkmark.square.fill" : "checkmark.square")
////                            .foregroundColor(.black)
////                    }
////                    Text("Anonymous")
////                    Button{
////                        viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
////                    } label : {
////                        Image(systemName: "paperplane")
////                            .foregroundColor(.black)
////                    }
////                }
////                .padding()
////
////
////            }.onTapGesture {
////                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
////            }
////
////        }
////        .navigationBarTitleDisplayMode(.inline)
////        .navigationBarBackButtonHidden(true)
////        .navigationBarItems(
////            leading : Button {
////            self.presentationMode.wrappedValue.dismiss()
////        } label : {
////            Image(systemName : "chevron.backward")
////                .foregroundColor(.mainTheme)
////                .font(.system(size : 15, weight : .bold))
////        },
////            trailing:
////                Button {
////                    withAnimation {
////                        viewModel.isMenuClicked = true
////                        viewModel.showAction = true
////                    }
////                    //menu toggle
////                } label: {
////                    if viewModel.totalSecretPostDetail!.secretPostDetail.modifiable {
////                        Image(systemName : "ellipsis")
////                            .foregroundColor(.black)
////                            .font(.system(size : 15, weight : .bold))
////                    }
////                })
////
////        .actionSheet(isPresented: $viewModel.showAction) {
////            ActionSheet(
////                title: (viewModel.isMyComment) ? Text("Comment Options") : Text("Post Options"),
////                buttons: [
////                    .default((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")) { viewModel.showPostModify = true },
////                    .destructive((viewModel.isMyComment) ? Text("Delete Comment") : Text("Delete Post")) { viewModel.showConfirmDeletion = true },
////                    .cancel()
////                ]
////            )
////        }
////        .alert(isPresented: $viewModel.showConfirmDeletion) {
////            Alert(
////                title: Text("Confirmation"),
////                message: Text((viewModel.isMyComment) ? "Do you want to delete this comment?" : "Do you want to delete this post?"),
////                primaryButton: .destructive(Text("Yes"), action : {
////                    (viewModel.isMyComment) ? viewModel.deleteSecretComment() : viewModel.deleteSecretPost()
////                    self.presentationMode.wrappedValue.dismiss()
////                }),
////                secondaryButton: .cancel(Text("No")))
////        }
////        .background(
////            NavigationLink(
////                destination :
////                    WritingView(viewModel: WritingViewModel(accessToken: viewModel.token,
////                                                            postId : (viewModel.totalSecretPostDetail?.secretPostDetail.postId)!,
////                                                            isForModifying: true,
////                                                            isForSecretModifying: true))
////                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
////                isActive : $viewModel.showPostModify) { }
////        )
////
////    }
////}
//
//struct SecretCommentView : View {
//    private let viewModel : CommentViewModel
//    
//    init(viewModel : CommentViewModel) {
//        self.viewModel = viewModel
//    }
//    
//    var body : some View {
//        VStack{ //(alignment: .leading)
//            
//            HStack{
//                URLImage( //프로필 이미지
//                    URL(string : viewModel.profileImage)!
//                ) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                }
//                .frame(width : 40,
//                       height: 40)
//                .cornerRadius(20)
//                
//                VStack{
//                    Text(viewModel.userName)
//                        .font(.system(size: 20, weight : .medium))
//                    
//                    //Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
//                    Text(viewModel.convertReturnedDateString(viewModel.createdAt))
//                        .font(.system(size: 10))
//                }
//            }
//            .foregroundColor(.black)
//            
//            Text(viewModel.content)
//            Divider()
//        }
//        .modifier(CommentStyle())
//    }
//}
//
