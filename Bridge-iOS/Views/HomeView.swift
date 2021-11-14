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
    @Binding var isSlideShow : Bool
    private let profileImage : String
    
    init(viewModel : HomeViewModel, isSlideShow : Binding<Bool>, profileImage : String) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isSlideShow = Binding(projectedValue: isSlideShow)
        self.profileImage = profileImage
    }
    
    var LocationPicker : some View {
        VStack {
            HStack (spacing : 20) {
                Button {
                    withAnimation { self.isSlideShow.toggle() }
                } label : {
                    Image(systemName: "text.justify")
                        .foregroundColor(.mainTheme)
                }
                
                URLImage(
                    URL(string : profileImage) ??
                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }.clipShape(Circle())
                .frame(
                    width : UIScreen.main.bounds.width * 0.04,
                    height: UIScreen.main.bounds.height * 0.04
                )

                VStack (alignment : .leading, spacing : 0) {
                    Text("Bridge in")
                        .font(.system(size : 10))
                    Picker("\(viewModel.selectedCamp)       ", selection: $viewModel.selectedCamp) {
                        ForEach(viewModel.locations, id: \.self) {
                            Text($0).foregroundColor(.gray)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .scaleEffect(1.4)
                    .padding(.horizontal, 30)
                }.accentColor(.black.opacity(0.8))
                Spacer()
            } // HStack

            NavigationLink {
                UsedSearchView()
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.horizontal, 3)
                    Text("Search")
                        .font(.system(size : 14))
                    Spacer()
                }
                .foregroundColor(.gray)
                .frame(
                    width: UIScreen.main.bounds.width * 0.95,
                    height : UIScreen.main.bounds.height * 0.035
                )
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
            }
            .padding(.vertical, 5)
        } // VStack
        .background(
            Color.white
                .edgesIgnoringSafeArea(.top)
                .shadow(color: .systemDefaultGray, radius: 4, x: 0, y: 4)
        )
    }
    
    var body : some View {
        VStack(spacing: 0) {
            LocationPicker
            HStack{
                Text("What's new today?")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    viewModel.getPosts(token: viewModel.token)
                } label : {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .foregroundColor(.gray)
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
                                ).onDisappear(perform: {
                                    // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
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
        HStack(spacing : 13) {
            URLImage(
                URL(string : viewModel.imageUrl) ??
                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width : UIScreen.main.bounds.width * 0.33,
                   height: UIScreen.main.bounds.height * 0.12)
            .cornerRadius(10)

            VStack(alignment : .leading){
                Text(viewModel.itemTitle)
                    .font(.title2)
                Spacer()
                Text("$ " + viewModel.itemPrice)
                    .font(.system(size: 20, weight : .bold))
                Spacer()
                HStack(spacing : 5) {
                    Text(viewModel.camp)
                    Text(viewModel.convertReturnedDateString(viewModel.post.createdAt)).fontWeight(.semibold)
                    Image(systemName : "eye")
                    Text("\(viewModel.viewCount)")
                    Spacer()
                    Image(systemName : viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.system(size : 20))
                }.font(.system(size : 9))
            }.foregroundColor(.secondary)
        }
        .modifier(ItemCardStyle())
    }
}
