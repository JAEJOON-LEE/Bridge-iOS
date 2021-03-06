//
//  CouponView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import SwiftUI
import Kingfisher

struct CouponView: View {
    @StateObject private var viewModel : CouponViewModel
    
    @Binding var isSlideShow : Bool
    @Binding var isLocationPickerShow : Bool
    @Binding var selectedDistrict : String
    
    init(viewModel : CouponViewModel, isSlideShow : Binding<Bool>, isLocationPickerShow : Binding<Bool>, selectedDistrict : Binding<String>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isSlideShow = Binding(projectedValue: isSlideShow)
        self._isLocationPickerShow = Binding(projectedValue: isLocationPickerShow)
        self._selectedDistrict = Binding(projectedValue: selectedDistrict)
    }
    
    var LocationPicker : some View {
        VStack(spacing : 0) {
            HStack (spacing : 25) {
                Button {
                    withAnimation { self.isSlideShow.toggle() }
                } label : {
                    Image(systemName: "text.justify")
                        .foregroundColor(.mainTheme)
                }
                KFImage(URL(string : viewModel.memberInfo.profileImage)
                        ?? URL(string : "https://static.thenounproject.com/png/741653-200.png")!)
                    .placeholder { ProgressView() }
                    .resizable()
                    .fade(duration: 0.5)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width : UIScreen.main.bounds.width * 0.065, height: UIScreen.main.bounds.height * 0.065)

                VStack (alignment : .leading, spacing : 0) {
                    Text("Bridge in")
                        .font(.system(size : 10, design : .rounded))
                    HStack {
                        Button {
                            withAnimation(.spring()) { isLocationPickerShow.toggle() }
                        } label : {
                            Text(selectedDistrict + " ▾")
                                .font(.system(size : 24, design: .rounded))
                        }
                    }
                }.foregroundColor(.darkGray)
                
                Spacer()
            } // HStack
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
                        NavigationLink(destination:
                            CouponInfoView(
                                memberId : viewModel.memberInfo.memberId,
                                viewModel: CouponInfoViewModel(shop.shopId, image : shop.image)))
                        {
                            HStack(spacing : 20) {
                                KFImage(URL(string : shop.image) ??
                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                                ).resizable()
                                .fade(duration: 0.5)
                                .aspectRatio(contentMode: .fill)
                                .frame(width : UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.12)
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
            
            if viewModel.shopsRandom.isEmpty {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.2)
            }
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(viewModel.shopsRandom, id : \.self) { shop in
                        NavigationLink(destination :
                            CouponInfoView(
                                memberId : viewModel.memberInfo.memberId,
                                viewModel:
                                    CouponInfoViewModel(shop.shopId, image : shop.image))
                        ) {
                            VStack {
                                KFImage(URL(string : shop.image) ??
                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                                ).resizable()
                                .fade(duration: 0.5)
                                .aspectRatio(contentMode: .fill)
                                .frame(width : UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.12)
                                .cornerRadius(10)
                                Text(shop.name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 3)
                                HStack(spacing :3) {
                                    Text(shop.benefit)
                                        .foregroundColor(.mainTheme)
                                    Spacer()
                                    Image(systemName : "text.bubble.fill")
                                    Text("\(shop.reviewCount)")
                                }
                                .frame(width : UIScreen.main.bounds.width * 0.3)
                                .foregroundColor(.secondary)
                                .font(.system(size: 9))
                            }.frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
                        }
                    }
                }
            }
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                .padding(.vertical, 10)

            // Category Selector
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
        .onChange(of: viewModel.selectedCategory) { _ in
            viewModel.getStore()
        }
        .onChange(of: selectedDistrict) { _ in
            viewModel.selectedCamp = selectedDistrict
            viewModel.getStore()
            viewModel.getRandomStore()
        }
    }
}
