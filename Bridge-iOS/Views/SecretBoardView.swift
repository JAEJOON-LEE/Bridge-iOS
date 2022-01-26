//
//  SecretBoardView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/22.
//

import SwiftUI
import URLImage
import SwiftUIPullToRefresh

struct SecretBoardView : View {
    @StateObject private var viewModel : BoardViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        
        VStack {
            RefreshableScrollView(onRefresh: { done in
                viewModel.getBoardPosts(token: viewModel.token)
                done()
            }){
                LazyVStack {
                    ForEach(viewModel.secretLists, id : \.self) { SecretList in
                        Button {
                        } label : {
                            SecretPost(viewModel : SecretViewModel(postList: SecretList))
                        }.background(
                            NavigationLink(
                                destination:
                                    PostInfoView(viewModel: PostInfoViewModel(
                                        token: viewModel.token,
                                        postId : SecretList.postId,
                                        memberId : viewModel.memberId,
                                        isMyPost : nil))
                            ){ }
                        )
                    }
                    .foregroundColor(Color.mainTheme)
                    .listStyle(PlainListStyle()) // iOS 15 대응
                    //            .frame(height:UIScreen.main.bounds.height * 1/7 )
                    
                }.listStyle(PlainListStyle()) // iOS 15 대응
                    .padding(.top, 5)
            }.padding(.top, 5)
        }.onAppear {
            usleep(200000)
            viewModel.getSecretPosts(token: viewModel.token)
        }
        .navigationBarTitle("S-SPACE", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading : Button {
                self.presentationMode.wrappedValue.dismiss()
            } label : {
                Image(systemName : "chevron.backward")
                    .foregroundColor(.black)
                    .font(.system(size : 15, weight : .bold))
            }
        )
        //        .refreshable{ // only for ios15
        //            viewModel.getBoardPosts(token: viewModel.token)
        //        }
    }
}


struct SecretPost : View {
    private let viewModel : SecretViewModel
    
    init(viewModel : SecretViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack(alignment : .leading){
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
                
                VStack(alignment : .leading){
                    Text(viewModel.userName)
                        .font(.system(size: 20, weight : .medium))
                    
                    //Text(viewModel.convertReturnedDateString(viewModel.createdAt ?? "2021-10-01 00:00:00"))
                    Text(viewModel.convertReturnedDateString(viewModel.createdAt))
                        .font(.system(size: 10))
                }
            }
            .foregroundColor(.black)
            .padding(.bottom, 2)
            
            if(viewModel.imageUrl != "null"){
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
            }
            
            HStack(alignment: .bottom){
                VStack(alignment: .leading){
                    Text(viewModel.postTitle)
                        .font(.system(size: 17, weight : .medium))
                    
                    if(viewModel.imageUrl == "null"){
                        Text(viewModel.description)
                            .font(.system(size: 13))
                    }
                }
                
                Spacer()
                
                
                Image(systemName: "message.fill")
                    .font(.system(size: 10, weight : .medium))
                Text(String(viewModel.commentCount))
                    .font(.system(size: 10, weight : .medium))
                
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 10, weight : .medium))
                    .foregroundColor(.mainTheme)
                Text(String(viewModel.likeCount))
                    .font(.system(size: 10, weight : .medium))
            }.foregroundColor(.black)
        }
        .modifier(GeneralPostStyle())
        //        .frame(height: viewModel.imageUrl != "null" ? UIScreen.main.bounds.height * 0.27 : UIScreen.main.bounds.height * 0.18)
    }
}
//
//struct SecretPost : View {
//    private let viewModel : SecretViewModel
//
//    init(viewModel : SecretViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body : some View {
//        VStack{
//                Text(viewModel.postTitle)
//                    .font(.system(size: 15, weight : .medium))
//
//                HStack{
//                    Group{
//                        Image(systemName: "hand.thumbsup.fill")
//                            .font(.system(size: 10))
//                            .foregroundColor(.mainTheme)
//                        Text(String(viewModel.likeCount))
//                            .font(.system(size: 10, weight : .medium))
//                            .foregroundColor(.black)
//                    }
//
//                    Group{
//                        Image(systemName: "message.fill")
//                            .font(.system(size: 10))
//                        Text(String(viewModel.commentCount))
//                            .font(.system(size: 10, weight : .medium))
//                    }.foregroundColor(.black)
//                }
//            }
//        .modifier(SpecialPostStyle())
//    }
//}


