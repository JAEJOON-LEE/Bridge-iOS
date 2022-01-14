//
//  CouponView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import SwiftUI
import URLImage

struct CouponView: View {
    @StateObject private var viewModel = CouponViewModel()
    @Binding var isSlideShow : Bool
    private let profileImage : String
    
    //init(viewModel : HomeViewModel, isSlideShow : Binding<Bool>, profileImage : String) {
    //    self._viewModel = StateObject(wrappedValue: viewModel)
    init(isSlideShow : Binding<Bool>, profileImage : String) {
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
                //viewModel.isSearchViewShow = true
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
    var Stores : some View {
        ScrollView {
            LazyVStack {
                if viewModel.shops.isEmpty {
                    VStack {
                        Image(systemName: "questionmark.folder")
                            .font(.system(size : 40))
                            .padding()
                        Text("Sorry, There is no coupons available.")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }.padding(20)
                    .foregroundColor(.secondary)
                }
                ForEach(viewModel.shops, id : \.self) { shop in
                    VStack {
                        NavigationLink(destination: CouponInfoView(viewModel: CouponInfoViewModel(shop.shopId))) {
                            HStack(spacing : 20) {
                                URLImage(
                                    URL(string : shop.image) ??
                                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                                ) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                //Color.systemDefaultGray // temp
                                .frame(width : UIScreen.main.bounds.width * 0.33,
                                       height: UIScreen.main.bounds.height * 0.12)
                                .cornerRadius(10)

                                VStack(alignment : .leading) {
                                    Text(shop.name)
                                        .font(.system(.title2, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(shop.benefit)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .foregroundColor(.mainTheme)

                                }.padding(.vertical, 10)
                                Spacer()
                            }
                            .padding(5)
                            .padding(.horizontal, 10)

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
    
    var body: some View {
        VStack(spacing: 0) {
            LocationPicker
            //추천 페이지 (상단)
            HStack{
                Text("How about this place?")
                    .font(.system(.title2, design : .rounded))
                    .fontWeight(.semibold)
                Spacer()
            }.foregroundColor(.gray)
            .padding(20)
            .padding(.vertical, 10)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
            HStack {
                Spacer()
                if !viewModel.shopsRandom.isEmpty {
                    NavigationLink(
                        destination : CouponInfoView(viewModel: CouponInfoViewModel(viewModel.shopsRandom[0].shopId))
                    ) {
                        VStack {
                            URLImage(
                                URL(string : viewModel.shopsRandom[0].image) ??
                                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                            ) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            //Color.systemDefaultGray // temp
                            .frame(width : UIScreen.main.bounds.width * 0.33,
                                   height: UIScreen.main.bounds.height * 0.12)
                            .cornerRadius(10)
                            Text(viewModel.shopsRandom[0].name)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.bottom, 3)
                            HStack(spacing :3) {
                                Text(viewModel.shopsRandom[0].benefit)
                                    .foregroundColor(.mainTheme)
                                Spacer()
                                Image(systemName : "text.bubble.fill")
                                Text("\(viewModel.shopsRandom[0].reviewCount)")
                            }
                            .frame(width : UIScreen.main.bounds.width * 0.3)
                            .foregroundColor(.secondary)
                            .font(.system(size: 9))
                        }.frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                    }
                }

                if viewModel.shopsRandom.count > 1 {
                    Spacer()
                    NavigationLink(
                        destination : CouponInfoView(viewModel: CouponInfoViewModel(viewModel.shopsRandom[1].shopId))
                    ) {
                        VStack {
                            URLImage(
                                URL(string : viewModel.shopsRandom[0].image) ??
                                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                            ) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            //Color.systemDefaultGray // temp
                            .frame(width : UIScreen.main.bounds.width * 0.33,
                                   height: UIScreen.main.bounds.height * 0.12)
                            .cornerRadius(10)
                            Text(viewModel.shopsRandom[1].name)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            HStack(spacing :3) {
                                Text(viewModel.shopsRandom[1].benefit)
                                    .foregroundColor(.mainTheme)
                                Spacer()
                                Image(systemName : "text.bubble.fill")
                                Text("\(viewModel.shopsRandom[1].reviewCount)")
                            }//.padding(5)
                            .frame(width : UIScreen.main.bounds.width * 0.33)
                            .foregroundColor(.secondary)
                            .font(.system(size: 10))
                        }.frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                    }
                }
                Spacer()
            }
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                .padding(.vertical, 10)

            HStack(spacing : 80) {
                Button {
                    withAnimation { viewModel.selectedCategory = 1 }
                } label : {
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size : 30))
                        Text("Restaurant")
                            .font(.caption2)
                    }.foregroundColor(.darkGray)
                }
                Button {
                    withAnimation { viewModel.selectedCategory = 2 }
                } label : {
                    VStack {
                        Image(systemName: "building.2.fill")
                            .font(.system(size : 30))
                        Text("Local Store")
                            .font(.caption2)
                    }.foregroundColor(.darkGray)
                }
                Button {
                    withAnimation { viewModel.selectedCategory = 3 }
                } label : {
                    VStack {
                        Image(systemName: "checkmark.seal")
                            .font(.system(size : 30))
                        Text("B-Selection")
                            .font(.caption2)
                    }.foregroundColor(.darkGray)
                }
            }.padding(.vertical, 5)
            ZStack {
                Color.systemDefaultGray
                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                HStack {
                    Color.gray
                        .opacity(viewModel.selectedCategory == 1 ? 1 : 0)
                        .frame(width : UIScreen.main.bounds.width * 0.2, height : 5)
                    Spacer()
                    Color.gray
                        .opacity(viewModel.selectedCategory == 2 ? 1 : 0)
                        .frame(width : UIScreen.main.bounds.width * 0.2, height : 5)
                    Spacer()
                    Color.gray
                        .opacity(viewModel.selectedCategory == 3 ? 1 : 0)
                        .frame(width : UIScreen.main.bounds.width * 0.2, height : 5)
                }.frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
            }.padding(.vertical, 10)
            
            Stores
        }.onAppear {
            viewModel.getStore()
            viewModel.getRandomStore()
        }
        .onChange(of: viewModel.selectedCategory) { _ in viewModel.getStore() }
    }
}
