//
//  PostInfoView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import SwiftUI
import URLImage
import SwiftUIPullToRefresh

enum ActiveAlert {
    case first, second, third
}

//@available(iOS 15.0, *)
struct PostInfoView: View { // 게시글 상세 페이지
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : PostInfoViewModel
//    @StateObject var notificationManager = LocalNotificationManager()
    @State var isLinkActive : Bool = false
    @State private var activeAlert : ActiveAlert = .first
    //    @FocusState private var focusField: Field?
    //    enum Field: Hashable {
    //        case commentfield
    //      } //대댓글 버튼 클릭 시, textfield로 focus //ios 15에서
    
    init(viewModel : PostInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        ScrollViewReader { commentArea in
        ZStack {
            VStack {
                
                ///
                ////
                ///
                ///
                //Profile
                HStack{
                    //                    if(viewModel.isSecret == false){

                    Button{
                        viewModel.isMemberInfoClicked.toggle()
                    } label : {
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
                    }
                    //                    }

                    HStack{
                        VStack(alignment: .leading){
                            if(viewModel.isSecret == false){
                                Text(viewModel.totalBoardPostDetail?.member?.username! ?? "Anonymous")
                                    .fontWeight(.bold)

                                Text(viewModel.convertReturnedDateString(viewModel.totalBoardPostDetail?.boardPostDetail.createdAt ?? "2021-10-01 00:00:00"))
                            }else{
                                Text("Anonymous")
                                    .fontWeight(.bold)

                                Text(viewModel.convertReturnedDateString(viewModel.totalSecretPostDetail?.secretPostDetail.createdAt ?? "2021-10-01 00:00:00"))
                            }
                        }
                        Spacer()
                    }
                }
                .padding()
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
                ///
                ///
                ///
                
                ///
                ///
                ///
                ///
                RefreshableScrollView(onRefresh: { done in
                    viewModel.getBoardPostDetail()
                    viewModel.getComment()
                    done()
                })
                    {
                ScrollView(.vertical, showsIndicators: false) {
                    //Images
                    ScrollView(.horizontal, showsIndicators: true) {
//                        HStack {
//                            if(viewModel.isSecret == false){
//                                ForEach(viewModel.totalBoardPostDetail?.boardPostDetail.postImages! ?? [], id : \.self) { imageInfo in
//                                    URLImage(
//                                        URL(string : imageInfo.image) ??
//                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                                    ) { image in
//                                        image
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width : viewModel.totalBoardPostDetail?.boardPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: viewModel.totalBoardPostDetail?.boardPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.height * 0.3 : UIScreen.main.bounds.height * 0.23)
//                                            .cornerRadius(10)
//                                            .padding(.horizontal)
//                                    }
//                                    .frame(width : viewModel.totalBoardPostDetail?.boardPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: viewModel.totalBoardPostDetail?.boardPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.height * 0.3 : UIScreen.main.bounds.height * 0.23)
//                                }
//                            }else {
//                                ForEach(viewModel.totalSecretPostDetail?.secretPostDetail.postImages! ?? [], id : \.self) { imageInfo in
//                                    URLImage(
//                                        URL(string : imageInfo.image) ??
//                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
//                                    ) { image in
//                                        image
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width : viewModel.totalSecretPostDetail?.secretPostDetail.postImages! .count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: viewModel.totalSecretPostDetail?.secretPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.height * 0.3 : UIScreen.main.bounds.height * 0.23)
//                                            .cornerRadius(10)
//                                            .padding(.horizontal)
//                                    }
//                                    .frame(width : viewModel.totalSecretPostDetail?.secretPostDetail.postImages! .count == 1 ? UIScreen.main.bounds.width * 0.93 : UIScreen.main.bounds.width * 0.58, height: viewModel.totalSecretPostDetail?.secretPostDetail.postImages!.count == 1 ? UIScreen.main.bounds.height * 0.3 : UIScreen.main.bounds.height * 0.23)
//                                }
//                            }
//                        }
//                        .padding()
                        /// 살려
                    }
                    
                    //Contents
                    VStack(alignment: .leading){
                        if(viewModel.isSecret == false){
                            Text(viewModel.totalBoardPostDetail?.boardPostDetail.title ?? "Title not found")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom)
                            
                            HStack{
                                Text(viewModel.totalBoardPostDetail?.boardPostDetail.description ?? "No description")
                            }
                        }else{
                            Text(viewModel.totalSecretPostDetail?.secretPostDetail.title ?? "Title not found")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack{
                                Text(viewModel.totalSecretPostDetail?.secretPostDetail.description ?? "No description")
                            }
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
                                if(viewModel.isSecret == false){
                                    viewModel.isLiked = viewModel.totalBoardPostDetail!.boardPostDetail.like
                                    viewModel.likePost(isliked: (viewModel.totalBoardPostDetail!.boardPostDetail.like))
                                }else{
                                    viewModel.isLiked = viewModel.totalSecretPostDetail!.secretPostDetail.like
                                    viewModel.likeSecretPost(isliked: (viewModel.totalSecretPostDetail!.secretPostDetail.like))
                                }
                                usleep(500000) // server is fuckin slow
                                if(viewModel.isSecret == false){
                                    viewModel.getBoardPostDetail()
                                }else{
                                    viewModel.getSecretPostDetail()
                                }
                                
//                                if(viewModel.isMyPost == false && viewModel.isLiked == false){
//                                    notificationManager.sendMessageTouser(to: notificationManager.ReceiverFCMToken, title: "Bridge", body: "Somebody likes your post!")
//                                }
                            } label : {
                                
                                if(viewModel.isSecret == false){
                                    Image((viewModel.totalBoardPostDetail?.boardPostDetail.like ?? true) ? "like" : "like_border")
                                        .foregroundColor(.mainTheme)
                                        .font(.system(size : 10))
                                }else{
                                    Image((viewModel.totalSecretPostDetail?.secretPostDetail.like ?? true) ? "like" : "like_border")
                                        .foregroundColor(.mainTheme)
                                        .font(.system(size : 10))
                                }
                            }
                            if(viewModel.isSecret == false){
                                Text(String((viewModel.totalBoardPostDetail?.boardPostDetail.likeCount ?? 0)) )
                            }else{
                                Text(String((viewModel.totalSecretPostDetail?.secretPostDetail.likeCount ?? 0)) )
                            }
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
                        commentView
                    }.listStyle(PlainListStyle()) // iOS 15 대응
                        .id("COMMENT_AREA")
                }
                }
                ///
                ///
                ///
                
                Divider()
                
                //Comment Input Area
                HStack{
                    TextField(viewModel.contentForViewing, text: $viewModel.commentInput)
                    //                        .focused($focusField, equals: .commentfield)
                        .autocapitalization(.none)
                        .accentColor(.mainTheme)
                    
                    Spacer()
                    
                    HStack {
//                        Text("Anonymous").foregroundColor(.gray)
                        Button {
                            viewModel.isAnonymous.toggle()
                        } label : {
                            Capsule()
//                                .fill(!viewModel.isAnonymous ? Color.gray : Color.mainTheme)
                                .foregroundColor(!viewModel.isAnonymous ? Color.gray : Color.mainTheme)
                                .frame(width: 110, height: 36)
                                .overlay(
                                    Button {
                                        viewModel.isAnonymous.toggle()
                                    } label : {
                                        Spacer(minLength: 55)
                                    }
                                )
                                .overlay(
                                    //send button
                                    HStack{
                                        Spacer()
                                        Image("anonymous1")
                                            .resizable()
                                            .aspectRatio(CGSize(width : 0.7, height : 0.5), contentMode: .fit)
                                            
                                        Spacer()
                                            Button{
                                                if(viewModel.commentInput.count != 0){
                                                    if(viewModel.isCocCliked){
                                                        if(viewModel.isSecret == false){
                                                            viewModel.sendCommentOfComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous), cocId: viewModel.commentId!)
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getBoardPostDetail()
                                                            viewModel.getComment()
                                                            viewModel.isCocCliked = false
                                                        }
                                                        else{
                                                            viewModel.sendSecretCommentOfComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous), cocId: viewModel.commentId!)
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getSecretPostDetail()
                                                            viewModel.getSecretComment()
                                                            viewModel.isCocCliked = false
                                                        }
                                                    }
                                                    else if(viewModel.showCommentModify == true){
                                                        if(viewModel.isSecret == false){
                                                            viewModel.patchComment(content: viewModel.commentInput)
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getBoardPostDetail()
                                                            viewModel.getComment()
                                                            viewModel.isCocCliked = false
                                                        }
                                                        else{
                                                            viewModel.patchSecretComment(content: viewModel.commentInput)
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getSecretPostDetail()
                                                            viewModel.getSecretComment()
                                                            viewModel.isCocCliked = false
                                                        }
                                                        viewModel.showCommentModify = false
                                                    }
                                                    else{
                                                        if(viewModel.isSecret == false){
                                                            viewModel.sendComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getBoardPostDetail()
                                                            viewModel.getComment()
                                                            viewModel.isCocCliked = false
                                                        }else{
                                                            viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                                                            viewModel.contentForViewing = "Write a comment."
                                                            viewModel.contentForPatch = ""
                                                            viewModel.commentInput = ""
                                                            viewModel.getSecretPostDetail()
                                                            viewModel.getSecretComment()
                                                            viewModel.isCocCliked = false
                                                        }
                                                    }
                                                    withAnimation {
                                                        viewModel.isProgressShow = true
                                                        viewModel.commentSended = true
                                                        viewModel.isAnonymous = false
                                                        usleep(300)
                                                        commentArea.scrollTo("COMMENT_AREA", anchor: .bottom)
                        //                                viewModel.getBoardPostDetail()
                        //                                viewModel.getComment()
                        //                                commentArea.scrollTo(viewModel.commentLists.count, anchor: .bottom)
                                                    }
                                                    
                        //                            if(viewModel.isMyPost == false){
                        //                                notificationManager.sendMessageTouser(to: notificationManager.ReceiverFCMToken, title: "Bridge", body: "Check a new comment of your post!")
                        //                            }
                                                }else{
                                                    viewModel.commentSended = false
                                                    viewModel.showCommentAlert = true
                                                    self.activeAlert = .second
                                                    viewModel.isAlertShow = true
                                                }
                                                viewModel.getComment()
                                            } label : {
                                                Capsule()
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .background(Capsule().foregroundColor(Color.mainTheme))
                                                    .frame(width: 60, height: 36)
//                                                    .cornerRadius(60)
                                                    .overlay(
                                                        Image("send")
                                                            .resizable()
                                                            .aspectRatio(CGSize(width : 0.8, height : 0.7), contentMode: .fit)
                                                    )
                                            }
                                    }
                                )
                            
//                                .overlay(
//                                    Image("anonymous1")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .foregroundColor(.black)
//                                        .overlay(
//                                            Image("anonymous2")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fill)
//                                                .overlay(
//                                                    Image("anonymous3")
//                                                        .resizable()
//                                                        .aspectRatio(contentMode: .fill)
//                                                )
//                                        )
//                                )
//                            Image(systemName: !viewModel.isAnonymous ? "square" : "checkmark.square.fill")
//                                .foregroundColor(!viewModel.isAnonymous ? .gray : .mainTheme)
//
                        }
                    }
                }
                .padding()
            
            }.onTapGesture {
                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
            }
            .blur(radius: viewModel.isMemberInfoClicked ? 3 : 0)
            
            if viewModel.isMemberInfoClicked {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation { viewModel.isMemberInfoClicked = false }
                        } label : {
                            Image(systemName: "xmark.circle")
                                .font(.system(size : 20, weight : .bold))
                                .foregroundColor(.white)
                        }.padding()
                    }.frame(height: 50)
                    
                    URLImage(
                        URL(string : viewModel.totalBoardPostDetail?.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                    .shadow(radius: 5)
                    
                    Text(viewModel.totalBoardPostDetail?.member?.username ?? "Unknown UserName")
                        .font(.system(size : 20, weight : .bold))
                        .foregroundColor(.white)
                    Text("\"" + (viewModel.totalBoardPostDetail?.member?.description  ?? "User not found") + "\"")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(width : UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 1/3)
                .background(Color.mainTheme)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            
//            if viewModel.isProgressShow {
//                HStack (spacing : 20) {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: Color.mainTheme))
//                    Text("Loading...")
//                        .foregroundColor(.darkGray)
//                }
//                .frame(width : UIScreen.main.bounds.width * 0.6, height : UIScreen.main.bounds.height * 0.15)
//                .cornerRadius(30)
//                .background(Color.white.shadow(radius: 3))
//            }
        }.onAppear {
            if(viewModel.isMyPost != nil){
                viewModel.contentForViewing = "Write a comment."
                viewModel.contentForPatch = ""
                viewModel.commentInput = ""
                viewModel.getBoardPostDetail()
                viewModel.getComment()
                viewModel.showAction = false
                viewModel.showAction2 = false
                viewModel.isMenuClicked = false
            }else{
//                viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                viewModel.contentForViewing = "Write a comment."
                viewModel.contentForPatch = ""
                viewModel.commentInput = ""
                viewModel.getSecretPostDetail()
                viewModel.getSecretComment()
                viewModel.showAction = false
                viewModel.showAction2 = false
                viewModel.isMenuClicked = false
            }
        }
        .onDisappear {
            if(viewModel.isMyPost != nil){
                viewModel.contentForViewing = "Write a comment."
                viewModel.contentForPatch = ""
                viewModel.commentInput = ""
                viewModel.getBoardPostDetail()
                viewModel.getComment()
            }else{
//                viewModel.sendSecretComment(content: viewModel.commentInput, anonymous: String(viewModel.isAnonymous))
                viewModel.contentForViewing = "Write a comment."
                viewModel.contentForPatch = ""
                viewModel.commentInput = ""
                viewModel.getSecretPostDetail()
                viewModel.getSecretComment()
            }
        }
        .onChange(of: viewModel.commentSended, perform: { _ in
            
                viewModel.getComment()
                viewModel.getSecretComment()
                usleep(300)
            
                if(viewModel.isMyPost != nil){
                    viewModel.getComment()
                    withAnimation{
                        commentArea.scrollTo("COMMENT_AREA", anchor: .bottom)
                    }
                }else{
                    viewModel.getSecretComment()
                    withAnimation{
                        commentArea.scrollTo("COMMENT_AREA", anchor: .bottom)
                    }
                }
            
            viewModel.commentSended = false
            withAnimation{
                usleep(300)
                commentArea.scrollTo("COMMENT_AREA", anchor: .bottom)
            }
        })
        .onChange(of: viewModel.isProgressShow, perform: { _ in
            
                if(viewModel.isMyPost != nil){
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getBoardPostDetail()
                    viewModel.getComment()
                }else{
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getSecretPostDetail()
                    viewModel.getSecretComment()
                }
            
            viewModel.isProgressShow = false
            withAnimation{
                usleep(300)
                commentArea.scrollTo("COMMENT_AREA", anchor: .bottom)
            }
        })
        .onChange(of: viewModel.showConfirmDeletion, perform: { _ in
            
                if(viewModel.isMyPost != nil){
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getBoardPostDetail()
                    viewModel.getComment()
                }else{
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getSecretPostDetail()
                    viewModel.getSecretComment()
                }
        })
        .onChange(of: viewModel.showAction, perform: { _ in
            
                if(viewModel.isMyPost != nil){
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getBoardPostDetail()
                    viewModel.getComment()
//                    viewModel.isMenuClicked = false
//                    viewModel.isMyComment = false
                }else{
                    viewModel.contentForViewing = "Write a comment."
                    viewModel.contentForPatch = ""
                    viewModel.commentInput = ""
                    viewModel.getSecretPostDetail()
                    viewModel.getSecretComment()
//                    viewModel.isMenuClicked = false
//                    viewModel.isMyComment = false
                }
        })
//        .onChange(of: viewModel.isLiked, perform: { _ in
//            viewModel.showAction3 = false
//            viewModel.getBoardPostDetail()
//        })
//        .onChange(of: viewModel.isLiked, perform: { _ in
//
//            if(viewModel.isSecret == false){
//                viewModel.likePost(isliked: (viewModel.isLiked))
//                viewModel.getBoardPostDetail()
//
////                viewModel.isLiked = viewModel.totalBoardPostDetail!.boardPostDetail.like
//            }else{
//                viewModel.getSecretPostDetail()
//                viewModel.likeSecretPost(isliked: (viewModel.isLiked))
//
////                viewModel.isLiked = viewModel.totalBoardPostDetail!.boardPostDetail.like
//            }
//        })
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
                        
                        viewModel.isMyComment = false
                        if(viewModel.isMyPost == false){
                            viewModel.isPostReport = true
                        }
                    }
                    //menu toggle
                } label: {
                        Image(systemName : "ellipsis")
                            .foregroundColor(.black)
                            .font(.system(size : 15, weight : .bold))
                }
        )
        .actionSheet(isPresented: $viewModel.showAction, content: getActionSheet)
        .alert(isPresented: $viewModel.isAlertShow) {
            switch activeAlert {
                case .first:
                    return Alert(title: Text("Report"),
                                 message: Text("Your report has been successfully received."),
                                 dismissButton: .default(Text("Close")))
                case .second:
                    return Alert(title: Text("Alert"),
                                 message: Text("Please fill the comment"),
                                 dismissButton: .default(Text("Close")))
                case .third:
                    return
                        Alert(
                            title: Text("Confirmation"),
                            message: Text((viewModel.isMyComment) ? "Do you want to delete this comment?" : "Do you want to delete this post?"),
                            primaryButton: .destructive(Text("Yes"), action : {
                                if(viewModel.isSecret == false){
                                    if(viewModel.isMyComment){
                                        viewModel.deleteComment()
                                        viewModel.getBoardPostDetail()
                                        viewModel.getComment()
                                        viewModel.showAction = false
                                    }
                                    else{
                                        viewModel.deletePost()
                                        self.presentationMode.wrappedValue.dismiss()
                                        viewModel.showAction = false
                                    }
                                }else{
                                    if(viewModel.isMyComment){
                                        viewModel.deleteSecretComment()
                                        viewModel.getSecretPostDetail()
                                        viewModel.getSecretComment()
                                        viewModel.showAction = false
                                    }
                                    else{
                                        viewModel.deleteSecretPost()
                                        self.presentationMode.wrappedValue.dismiss()
                                        viewModel.showAction = false
                                    }
                                }

                            }),
                            secondaryButton: .cancel(Text("No")))
                    
            }
        }
//        .alert(isPresented: $viewModel.isReportDone) {
//            Alert(title: Text("Report"),
//                  message: Text("Your report has been successfully received."),
//                  dismissButton: .default(Text("Close")))
//        }
//        .alert(isPresented: $viewModel.showCommentAlert) {
//            Alert(title: Text("Alert"),
//                  message: Text("Please fill the comment"),
//                  dismissButton: .default(Text("Close")))
//        }
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
//                            viewModel.showAction = false
//                        }
//                        else{
//                            viewModel.deletePost()
//                            self.presentationMode.wrappedValue.dismiss()
//                            viewModel.showAction = false
//                        }
//                    }else{
//                        if(viewModel.isMyComment){
//                            viewModel.deleteSecretComment()
//                            viewModel.getSecretPostDetail()
//                            viewModel.getSecretComment()
//                            viewModel.showAction = false
//                        }
//                        else{
//                            viewModel.deleteSecretPost()
//                            self.presentationMode.wrappedValue.dismiss()
//                            viewModel.showAction = false
//                        }
//                    }
//
//                }),
//                secondaryButton: .cancel(Text("No")))
//        }
        .background(
            NavigationLink(
                destination :
                    WritingView(viewModel: WritingViewModel(accessToken: viewModel.token,
                                                            postId : viewModel.postId,
                                                            isForModifying: (viewModel.isSecret) ? false : true,
                                                            isForSecretModifying : (viewModel.isSecret) ? true : false))
                    .navigationBarTitle((viewModel.isMyComment) ? Text("Modify Comment") : Text("Modify Post")),
                isActive : $viewModel.showPostModify) { }
        )
    }
}
    
    func getActionSheet() -> ActionSheet {
        let btnMC: ActionSheet.Button = (
            .default(Text("Modify Comment")){
                viewModel.showCommentModify = true
                viewModel.contentForViewing = viewModel.contentForPatch
        })
        
        let btnMP: ActionSheet.Button = (
            .default(Text("Modify Post")){
                viewModel.showPostModify = true
        })
        
        let btnDC: ActionSheet.Button = (
            .destructive(Text("Delete Comment")) {
            viewModel.showConfirmDeletion = true
                self.activeAlert = .third
            viewModel.isAlertShow = true

        })
        
        let btnDP: ActionSheet.Button = (
            .destructive(Text("Delete Post")) {
            viewModel.showConfirmDeletion = true
            self.activeAlert = .third
            viewModel.isAlertShow = true

        })
        
        let btnReport: ActionSheet.Button = (
            .default(Text("Report")){
                // 신고 기능
                viewModel.isMenuClicked = false
                viewModel.isReportDone = true
                self.activeAlert = .first
                viewModel.isAlertShow = true
                if(viewModel.isPostReport == false){
                    //댓글
                    viewModel.reportComment()
                }else{
                    //게시물
                    viewModel.reportPost()
                }
            })
        
        let btnCancle: ActionSheet.Button = .cancel()
        
        if((viewModel.isMyComment == true)){
            return ActionSheet(title: Text("Options"), message: nil, buttons: [btnMC, btnDC, btnCancle])
        }
        else if(viewModel.isMyPost == true ){
            if(viewModel.isMyComment == false && viewModel.isNotMyComment == true){
               return ActionSheet(title: Text("Option"), message: nil, buttons: [btnReport, btnCancle])
            }
            else{
                return ActionSheet(title: Text("Options"), message: nil, buttons: [btnMP, btnDP, btnCancle])
            }
        }else if((viewModel.totalSecretPostDetail?.secretPostDetail.modifiable == true)){
            return ActionSheet(title: Text("Options"), message: nil, buttons: [btnMP, btnDP, btnCancle])
        }else if((viewModel.totalBoardPostDetail?.boardPostDetail.modifiable == true)){
            return ActionSheet(title: Text("Options"), message: nil, buttons: [btnMP, btnDP, btnCancle])
        }else{
            return ActionSheet(title: Text("Option"), message: nil, buttons: [btnReport, btnCancle])
        }
    }
}

extension PostInfoView {
    var commentView : some View {

        ///
        ///
        ///
        ScrollViewReader{ proxyReader in
        ForEach(viewModel.commentLists, id : \.self) { Comment in

            VStack(alignment: .leading){
                HStack{
                    URLImage( //프로필 이미지
                        URL(string : (Comment.member?.profileImage) ?? "https://static.thenounproject.com/png/741653-200.png") ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
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
                            Text(Comment.member?.username! ?? "Anonymous" )
                                .font(.system(size: 20, weight : .medium))

                            Text(viewModel.convertReturnedDateString(Comment.createdAt ?? "2021-10-01 00:00:00"))
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.top, -20)

                Text(Comment.content)
                    .padding(.leading, 50)

                HStack{
                    Spacer()


                    Button{
                        //댓글 라이크 버튼 클릭
                        viewModel.isCommentLiked = Comment.like
                        viewModel.commentItem = Comment
                        viewModel.commentId = Comment.commentId
                        viewModel.likeComment(isCommentliked: viewModel.isCommentLiked)


                        if(viewModel.isSecret == false){
                            viewModel.getComment()
                        }else{
                            viewModel.getSecretComment()
                        }
                        
//                        if(Comment.like == false){
//                            notificationManager.sendMessageTouser(to: notificationManager.ReceiverFCMToken, title: "Bridge", body: "Somebody likes your comment!")
//                        }
                    } label : {
                        Image((Comment.like) ? "like" : "like_border")
                            .foregroundColor(.mainTheme)
                            .font(.system(size : 10))
//                        Image(systemName: (viewModel.isLiked ?? true) ? "hand.thumbsup.fill" : "hand.thumbsup")
//                            .foregroundColor(.mainTheme)
                    }
                    Text(String((Comment.likeCount)))
                        .padding(.trailing)

                    Button{
                        //대댓글 클릭
                        viewModel.isCocCliked = true
                        viewModel.commentId = Comment.commentId
                        //                        commentId = viewModel.commentId
                        viewModel.contentForViewing = "@" + (Comment.member?.username! ?? "Anonymous")
                        //                            viewModel.likeComment(isliked: (viewModel.commentList.like ?? true))
                    } label : {
                        Image(systemName: "message.fill")
                            .foregroundColor(.black)
                            .padding(.bottom, 1)
                    }
                }
                .font(.system(size: 13))

                // 대댓글
//                ForEach(Comment.comments!, id : \.self) { Coc in
//
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
//                                    Text(Coc.member?.username! ?? "Anonymous" )
//                                        .font(.system(size: 15, weight : .medium))
//
//                                    Text(viewModel.convertReturnedDateString(Coc.createdAt ?? "2021-10-01 00:00:00"))
//                                        .font(.system(size: 11))
//
//                                }
//                                .foregroundColor(.gray)
//
//                                Spacer()
//
//                                    Button { // menu button
//                                            viewModel.isMenuClicked = true
//                                            viewModel.showAction = true
//                                            viewModel.isMyComment = true
//                                            viewModel.commentId = Coc.commentId
//                                            viewModel.contentForPatch = Coc.content
//
//                                            //menu toggle
//                                    } label: {
//                                        if (Coc.modifiable) {
//                                            Image(systemName : "ellipsis")
//                                                .foregroundColor(.black)
//                                                .font(.system(size : 15, weight : .bold))
//                                        }
//                                    }
//                            }
//                            .frame(alignment: .leading)
//
//                            Text(Coc.content)
//                                .padding(.leading, 40)
//
//                            HStack{
//                                Spacer()
//
//                                Button{
//                                    //댓글 라이크 버튼 클릭
//
//                                    viewModel.isCocLiked = Coc.like
//                                    viewModel.commentItem = Coc
//                                    viewModel.commentId = Coc.commentId
//                                    viewModel.likeCommentOfComment(isliked: viewModel.isCocLiked, cocId: Coc.commentId )
//
//
//                                    if(viewModel.isSecret == false){
//                                        viewModel.getComment()
//                                    }else{
//                                        viewModel.getSecretComment()
//                                    }
//                                } label : {
//                                    Image(systemName: (Coc.like) ? "hand.thumbsup.fill" : "hand.thumbsup")
//                                        .foregroundColor(.mainTheme)
//                                }
//                                Text(String((Coc.likeCount)))
//                                    .padding(.trailing)
//
//                                Button{
//                                    //대댓글 클릭
//                                    viewModel.isCocCliked = true
//                                    viewModel.commentId = Comment.commentId
//                                    viewModel.contentForViewing = "@" + (Comment.member?.username! ?? "Anonymous")
//                                } label : {
//                                    Image(systemName: "message.fill")
//                                        .foregroundColor(.black)
//                                        .padding(.bottom, 2)
//                                }
//                            }
//                        }
//                        .font(.system(size: 11))
//                        .padding()
//                        .frame(width : 250, alignment: .trailing)
//                        .background(Color.systemDefaultGray)
//                        .cornerRadius(20)
//                    }
//                    .frame(alignment : .leading)
//                }
                    Divider()
                    .frame(height : 2)
                }
                .modifier(CommentStyle())
                .overlay(
                    Button { // menu button
                        withAnimation {
                            if (Comment.modifiable) {
                                viewModel.isMenuClicked = true
                                viewModel.showAction = true
                                viewModel.isMyComment = true
                                viewModel.isNotMyComment = false
                                viewModel.commentId = Comment.commentId
                                viewModel.contentForPatch = Comment.content
                            }else{
                                viewModel.isMyComment = false
                                viewModel.isMenuClicked = true
                                viewModel.showAction = true
                                viewModel.commentId = Comment.commentId
                                viewModel.isNotMyComment = true
                                viewModel.isPostReport = false
                            }
                        }
                            //menu toggle
                    } label: {
//                        if (Comment.modifiable) {
                            Image(systemName : "ellipsis")
                                .foregroundColor(.black)
                                .font(.system(size : 15, weight : .bold))
//                        }
                    }
                    , alignment : .topTrailing
                )
        }
        .id("SCROLL_TO_BOTTOM")
        }
        ///
        ///
        ///
    }
}
