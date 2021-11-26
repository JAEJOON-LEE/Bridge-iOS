//
//  UsedSearchView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/14.
//

import SwiftUI

struct UsedSearchView : View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : UsedSearchViewModel
    
    init(viewModel : UsedSearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing : 15) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 5)
                    TextField("Search", text: $viewModel.searchString, onCommit : {
                        //print("return press and content is \(viewModel.searchString)")
                        viewModel.getPostsByQuery(query: viewModel.searchString)
                        viewModel.searchResultViewShow = true
                    })
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                }
                .foregroundColor(.gray)
                .frame(
                    width: UIScreen.main.bounds.width * 0.77,
                    height : UIScreen.main.bounds.height * 0.035
                )
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                }
                label : {
                    Text("Back")
                        .foregroundColor(.darkGray)
                        .fontWeight(.semibold)
                }
            }
            // Category
            HStack {
                Text("Categories")
                    .foregroundColor(.mainTheme)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal, 20)
            
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
            ) {
                ForEach(viewModel.categories, id : \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                        viewModel.getPostsByCategory(category: category)
                        viewModel.categoryViewShow = true
                    } label : {
                        VStack(spacing : 5) {
                            Image(category)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(25)
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.2,
                                    height: UIScreen.main.bounds.width * 0.2)
                                .background(Color.systemDefaultGray)
                                .cornerRadius(20)
                            
                            Text(category)
                                .foregroundColor(.darkGray)
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                    }.padding(.bottom, 10)
                }
            }
            
            // Hot Deal
            HStack {
                Text("\(viewModel.currentCamp) Hot Deal")
                    .foregroundColor(.mainTheme)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal, 20)
            
            ScrollView { //hot deal 개수가 3개 이상이면 필요
                LazyVStack {
                    ForEach(viewModel.hotDealPosts, id : \.self) { Post in
                        NavigationLink(
                            destination:
                                ItemInfoView(viewModel:
                                                ItemInfoViewModel(
                                                    token: viewModel.token,
                                                    postId : Post.postId,
                                                    isMyPost : (viewModel.memberId == Post.memberId)
                                                )
                                )
                                .onDisappear(perform: {
                                    // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
                                    viewModel.getHotDealPosts()
                                })
                        ) {
                            ItemCard(viewModel : ItemCardViewModel(post: Post))
                        }
                    }
                }
                //}
                if (viewModel.hotDealPosts.isEmpty) { Spacer() }
            } // ScrollView
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .background(
            NavigationLink(
                destination :
                    ScrollView {
                        LazyVStack {
                            if (viewModel.Posts.isEmpty) {
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
                                        Text("any posts in")
                                            .foregroundColor(.darkGray)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                        Text(viewModel.selectedCategory)
                                            .foregroundColor(.mainTheme)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                    }
                                }.padding(.top, UIScreen.main.bounds.height * 0.2)
                            }
                            else {
                            ForEach(viewModel.Posts, id : \.self) { Post in
                                NavigationLink(
                                    destination:
                                        ItemInfoView(viewModel:
                                                        ItemInfoViewModel(
                                                            token: viewModel.token,
                                                            postId : Post.postId,
                                                            isMyPost : (viewModel.memberId == Post.memberId)
                                                        )
                                        )
                                        .onDisappear(perform: {
                                            // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
                                            viewModel.getPostsByCategory(category: viewModel.selectedCategory)
                                        })
                                ) {
                                    ItemCard(viewModel : ItemCardViewModel(post: Post))
                                }
                            }
                            }
                        }
                    }.navigationTitle(Text(viewModel.selectedCategory)),
                isActive : $viewModel.categoryViewShow) { }
        )
        .background(
            NavigationLink(
                destination :
                    ScrollView {
                        LazyVStack {
                            if (viewModel.searchedPosts.isEmpty) {
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
                                ForEach(viewModel.searchedPosts, id : \.self) { Post in
                                    NavigationLink(
                                        destination:
                                            ItemInfoView(viewModel:
                                                            ItemInfoViewModel(
                                                                token: viewModel.token,
                                                                postId : Post.postId,
                                                                isMyPost : (viewModel.memberId == Post.memberId)
                                                            )
                                            )
                                            .onDisappear(perform: {
                                                // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
                                                viewModel.getPostsByQuery(query: viewModel.searchString)
                                            })
                                    ) {
                                        ItemCard(viewModel : ItemCardViewModel(post: Post))
                                    }
                                }
                            }
                        }
                    }.navigationTitle(Text("Posts about \"\(viewModel.searchString)\"")),
                isActive : $viewModel.searchResultViewShow) { }
        )
    }
}
