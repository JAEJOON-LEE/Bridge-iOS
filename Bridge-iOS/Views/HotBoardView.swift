//
//  HotBoardView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/22.
//

import SwiftUI
import SwiftUIPullToRefresh

struct HotBoardView : View {
    @StateObject private var viewModel : BoardViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack {
            if (viewModel.hotLists.count == 0){
                Text("No Hot Posts")
            } else{
                RefreshableScrollView(onRefresh: { done in
                    viewModel.getBoardPosts(token: viewModel.token)
                    done()
                }) {
                    LazyVStack {
                        ForEach(viewModel.hotLists, id : \.self) { HotList in
                            NavigationLink(
                                destination:
                                    PostInfoView(viewModel: PostInfoViewModel(
                                        token: viewModel.token,
                                        postId : HotList.postInfo.postId,
                                        memberId : viewModel.memberId,
                                        isMyPost : (viewModel.memberId == HotList.member?.memberId)))
                            ) {
                                GeneralPost(viewModel : GeneralPostViewModel(postList: HotList))
                            }
                        }
                        .foregroundColor(Color.mainTheme)
                        .listStyle(PlainListStyle()) // iOS 15 대응
                    }.listStyle(PlainListStyle()) // iOS 15 대응
                    .padding(.top, 5)
                }.padding(.top, 5)
            }
        }.onAppear {
            viewModel.getSecretPosts(token: viewModel.token)
        }
        .navigationBarTitle("Hot board", displayMode: .inline)
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
    }
}
