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
        VStack(spacing : 20) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 5)
                    TextField("", text: $viewModel.searchString)
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
            }
            
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())]
            ) {
                ForEach(viewModel.categories, id : \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                        viewModel.getPostsByCategory(category: category.lowercased())
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
            
            HStack {
                Text("\(viewModel.currentCamp) Hot Deal")
                    .foregroundColor(.mainTheme)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.vertical, 20)

            Spacer()
        }.padding(20)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .background(
            NavigationLink(
                destination :
                    ScrollView {
                        LazyVStack {
                            if (viewModel.Posts.isEmpty) {
                                    HStack {
                                        Text("No post in")
                                            .foregroundColor(.darkGray)
                                            .fontWeight(.semibold)
                                        Text(viewModel.selectedCategory)
                                            .foregroundColor(.mainTheme)
                                            .fontWeight(.semibold)
                                    }.font(.title)
                                    .padding(.top, UIScreen.main.bounds.height * 0.3)
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
                                            viewModel.getPostsByCategory(category: viewModel.selectedCategory.lowercased())
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
    }
}
