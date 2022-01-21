//
//  HomeView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/16.
//

import SwiftUI
import URLImage
import SwiftUIPullToRefresh

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
            HStack (spacing : 30) {
                Button {
                    withAnimation { self.isSlideShow.toggle() }
                } label : {
                    Image(systemName: "text.justify")
                        .foregroundColor(.mainTheme)
                }

                URLImage(
                    // MARK: - API 수정되면 교체해야됨. 현재 프로필 이미지가 주소가 아니고 파일명으로 옴
                    //URL(string : viewModel.memberInfo?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
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
                    HStack {
                        Picker("\(viewModel.selectedCamp)", selection: $viewModel.selectedCamp) {
                            ForEach(viewModel.locations, id: \.self) {
                                Text($0).foregroundColor(.gray)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .scaleEffect(1.4)
                        .padding(.leading, 15)
                        Image(systemName : "arrowtriangle.down.fill")
                                .padding(.leading, 15)
                                .font(.system(size : 15))
                                .foregroundColor(.darkGray)
                    }
                }.accentColor(.black.opacity(0.8))
                Spacer()
            } // HStack

            // Search
            Button {
                viewModel.isSearchViewShow = true
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
                    .font(.system(.title2, design : .rounded))
                    .fontWeight(.semibold)
                Spacer()
            }
            .foregroundColor(.gray)
            .padding(20)
            .padding(.vertical, 10)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
            
            if !viewModel.postFetchDone {
                Spacer()
                ProgressView()
                    .padding()
                Text("Loading..")
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                Spacer()
            } else {
                RefreshableScrollView(onRefresh: { done in
                    viewModel.getPosts()
                    done()
                }) {
                    LazyVStack {
                        ForEach(viewModel.Posts, id : \.self) { Post in
                            VStack {
                                NavigationLink(
                                    destination:
                                        ItemInfoView(viewModel:
                                                        ItemInfoViewModel(
                                                            postId : Post.postId,
                                                            isMyPost : (viewModel.memberId == Post.memberId)
                                                        )
                                        )/*.onDisappear(perform: {
                                            // 일반 작업시에는 필요없는데, 삭제 작업 즉시 반영을 위해서 필요함
                                            viewModel.getPosts(token: viewModel.token)
                                        })*/
                                ) {
                                    ItemCard(viewModel : ItemCardViewModel(post: Post))
                                }
                                
                                Color.systemDefaultGray
                                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                            }
                        }
                    }
                    Spacer().frame(height : UIScreen.main.bounds.height * 0.1)
                }.overlay(
                    VStack(spacing : 0) {
                        Spacer()
                        LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom)
                            .frame(height : UIScreen.main.bounds.height * 0.1)
                        Color.white
                            .frame(height : UIScreen.main.bounds.height * 0.05)
                    }.edgesIgnoringSafeArea(.bottom)
                )
            }
        }.onChange(of: SignInViewModel.accessToken) { _ in
            viewModel.getPosts()
        }.onAppear {
            viewModel.getPosts()
        }.onChange(of: viewModel.selectedCamp) { newValue in
            print(newValue)
            viewModel.getPosts()
        }
        .fullScreenCover(isPresented: $viewModel.isSearchViewShow) {
            print("full screen cover dissmiss action")
        } content: {
            NavigationView {
                UsedSearchView(viewModel:
                                UsedSearchViewModel(
                                    memberId: viewModel.memberId,
                                    currentCamp : viewModel.selectedCamp
                                )
                )
            }.accentColor(.mainTheme)
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
            .frame(width : UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.12)
            .cornerRadius(10)

            VStack(alignment : .leading, spacing: 5) {
                Text(viewModel.itemTitle)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.8))
                HStack(spacing : 5) {
                    Text(viewModel.camp)
                        .fontWeight(.light)
                    Text(convertReturnedDateString(viewModel.post.createdAt))
                        .fontWeight(.light)
                    Image(systemName : "eye")
                    Text("\(viewModel.viewCount)")
                        .fontWeight(.light)
                }.font(.system(size : 9))
                Spacer()
                HStack {
                    Text("$ " + viewModel.itemPrice)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                    Spacer()
                    Image(systemName : viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.system(size : 24))
                }
            }.foregroundColor(.secondary)
            .padding(.vertical, 7)
        }
        .padding(5)
        .padding(.horizontal, 10)
        //.modifier(ItemCardStyle())
    }
}
