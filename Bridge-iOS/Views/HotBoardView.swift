//
//  HotBoardView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/22.
//

import SwiftUI
import URLImage

struct HotBoardView : View {
    @StateObject private var viewModel : BoardViewModel
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body : some View {
        VStack {
            List {
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
//                    .buttonStyle(PlainButtonStyle())
                }
            .foregroundColor(Color.mainTheme)
            .listStyle(PlainListStyle()) // iOS 15 대응
//            .frame(height:UIScreen.main.bounds.height * 1/7 )
            
            }.listStyle(PlainListStyle()) // iOS 15 대응
        }.onAppear {
            viewModel.getSecretPosts(token: viewModel.token)
        }
//        .refreshable{ // only for ios15
//            viewModel.getBoardPosts(token: viewModel.token)
//        }
    }
}
