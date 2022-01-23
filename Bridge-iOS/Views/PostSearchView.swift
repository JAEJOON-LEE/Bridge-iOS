//
//  PostSearchView.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/11/22.
//

import Foundation
import SwiftUI

struct PostSearchView : View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : BoardViewModel
    
    init(viewModel : BoardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            ScrollView {
                ScrollViewReader { value in
        VStack(spacing : 15) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 5)
                    TextField("Search", text: $viewModel.searchString, onCommit : {
                        //print("return press and content is \(viewModel.searchString)")
                        viewModel.searchPosts(token: viewModel.token, query: viewModel.searchString)
                        viewModel.searchResultViewShow = true
                    })
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    .onChange(of: viewModel.searchString) { _ in
                        withAnimation {
                            value.scrollTo(1, anchor: .bottom)
                        }
                    }
                }
                .foregroundColor(.gray)
                .frame(
                    width: UIScreen.main.bounds.width * 0.75,
                    height : UIScreen.main.bounds.height * 0.035
                )
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                }
                label : {
                    Text("Back")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top)
            
        
            VStack {
                HStack{
                    Image("search")
                        .font(.system(size : 150))
                        .foregroundColor(.mainTheme)
                }
                .padding(.leading, 60)
                Text("Search the information")
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .frame(height: UIScreen.main.bounds.height * 0.88)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .background(
            NavigationLink(
                destination :
                    ScrollView {
                        LazyVStack {
                            if (viewModel.searchLists.isEmpty) {
                                VStack {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size : 150))
                                        .foregroundColor(.darkGray)
                                        .padding()
                                    Text("Sorry, We couldn't find")
                                        .foregroundColor(.darkGray)
                                        .fontWeight(.semibold)
                                        .font(.title)
                                    HStack {
                                        Text("any posts about")
                                            .foregroundColor(.darkGray)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                        Text(viewModel.searchString)
                                            .foregroundColor(.mainTheme)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                    }
                                }.padding(.top, UIScreen.main.bounds.height * 0.2)
                            }
                            else {
                                ForEach(viewModel.searchLists, id : \.self) { SearchList in
                                NavigationLink(
                                    destination:
                                        PostInfoView(viewModel: PostInfoViewModel(
                                                        token: viewModel.token,
                                                        postId : SearchList.postInfo.postId,
                                                        memberId : viewModel.memberId,
                                                        isMyPost : (viewModel.memberId == SearchList.member?.memberId)))
                                ) {
                                    GeneralPost(viewModel : GeneralPostViewModel(postList: SearchList))
                                    }
                                }
                            }
                        }
                    }.navigationTitle(Text("Search results of \"\(viewModel.searchString)\"")),
                isActive : $viewModel.searchResultViewShow) { }
        )
    }
}
        }
    }
}
