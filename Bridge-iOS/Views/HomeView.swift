//
//  HomeView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage

struct HomeView : View {
    @StateObject private var viewModel : HomeViewModel
    
    init(viewModel : HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var LocationPicker : some View {
        HStack(spacing : 5) {
            // Location Picker
            Picker("\(viewModel.selectedCamp )", selection: $viewModel.selectedCamp) {
                ForEach(viewModel.locations, id: \.self) {
                    Text($0)
                }
            }.font(.system(size : 15, weight : .bold))
            .pickerStyle(MenuPickerStyle())
            Image(systemName: "arrowtriangle.down.circle")
                .font(.system(size : 12))
                .foregroundColor(.mainTheme)
            Spacer()
            Button{
                print("search button clicked")
            } label : {
                Image(systemName: "magnifyingglass")
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.systemDefaultGray)
    }
    
    var body : some View {
        VStack(spacing: 0) {
            LocationPicker
            //ListHeader(name: "What's new today?").padding(.vertical, 10)
            HStack{
                Text("What's new today?")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    viewModel.getPosts(token: viewModel.token)
                } label : {
                    HStack(spacing : 5) {
                        Text("refresh")
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }.foregroundColor(.mainTheme)
            .padding(20)
            .padding(.vertical, 10)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.Posts, id : \.self) { Post in
                        NavigationLink(
                            destination:
                                ItemInfoView(viewModel:
                                                ItemInfoViewModel(
                                                    token: viewModel.token,
                                                    postId : Post.postId,
                                                    isMyPost : (viewModel.memberId == Post.memberId)
                                                )
                                ).onDisappear(perform: { // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
                                    viewModel.getPosts(token: viewModel.token)
                                })
                        ) {
                            ItemCard(viewModel : ItemCardViewModel(post: Post))
                        }//.buttonStyle(.plain)
                    }
                }
                Spacer().frame(height : UIScreen.main.bounds.height * 0.1)
            }
        }.onAppear {
            viewModel.getPosts(token: viewModel.token)
        }.onChange(of: viewModel.selectedCamp) { newValue in
            print(newValue)
            viewModel.getPosts(token: viewModel.token)
        }
    }
}

struct ItemCard : View {
    private let viewModel : ItemCardViewModel
    
    init(viewModel : ItemCardViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        HStack(spacing : 15) {
            URLImage(
                URL(string : viewModel.imageUrl) ??
                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width : UIScreen.main.bounds.width * 0.25,
                   height: UIScreen.main.bounds.height * 0.1)
            .cornerRadius(10)

            VStack(alignment : .leading){
                Text(viewModel.itemTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("$ " + viewModel.itemPrice)
                    .font(.system(size: 20, weight : .medium))
                Spacer()
                HStack {
                    Text(viewModel.camp)
                    Image(systemName : "eye")
                    Text("\(viewModel.viewCount)")
                    Spacer()
                    Image(systemName : viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.system(size : 20))
                }.font(.system(size : 12))
            }.foregroundColor(.secondary)
        }
        .modifier(ItemCardStyle())
    }
}
