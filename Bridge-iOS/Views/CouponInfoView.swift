//
//  CouponInfoView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import SwiftUI
import URLImage
import MapKit

struct CouponInfoView: View {
    @StateObject private var viewModel : CouponInfoViewModel
    
    let memberId : Int
    
    init(memberId : Int, viewModel : CouponInfoViewModel) {
        self.memberId = memberId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var StoreImages : some View {
        TabView(selection : $viewModel.currentImageIndex) {
            ForEach(viewModel.shopInfo.images, id : \.self) { imageInfo in
                URLImage(
                    URL(string : imageInfo.image) ??
                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .tag(imageInfo.imageId)
                .onTapGesture { viewModel.currentImageIndex = imageInfo.imageId }
            }
        }.tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
        .onTapGesture {
            viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
        }
        .fullScreenCover(isPresented: $viewModel.isImageTap) {
            ZStack(alignment : .topTrailing) {
                TabView(selection : $viewModel.currentImageIndex) {
                    ForEach(viewModel.shopInfo.images, id : \.self) { imageInfo in
                        URLImage(
                            URL(string : imageInfo.image) ??
                            URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }.tag(imageInfo.imageId)
                    }
                }.tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(width : UIScreen.main.bounds.width)
                .offset(x : 0, y : viewModel.ImageViewOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if -50 < gesture.translation.height && gesture.translation.height < 100 {
                                viewModel.ImageViewOffset = gesture.translation
                            } else if gesture.translation.height >= 100 {
                                viewModel.isImageTap.toggle()
                                viewModel.ImageViewOffset = .zero
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                viewModel.ImageViewOffset = .zero
                            }
                        }
                )
                
                Button {
                    viewModel.isImageTap.toggle()
                } label : {
                    Image(systemName : "xmark")
                        .foregroundColor(.mainTheme)
                        .font(.system(size : 20))
                        .padding()
                }
            }
        }
    }
    var Title : some View {
        VStack (alignment : .leading, spacing : 10) {
            HStack(spacing : 3) {
                VStack(alignment : .leading) {
                    Text(viewModel.shopInfo.name)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    Text(viewModel.shopInfo.benefit)
                        .foregroundColor(.mainTheme)
                        .font(.system(.headline, design: .rounded))
                }
                Spacer()
                Image(systemName : "text.bubble.fill")
                    .font(.system(size: 20))
                Text("\(viewModel.reviews.count)")
                    .font(.system(size: 20, design: .rounded))
                    .fontWeight(.semibold)
                    .padding(.trailing, 5)
            }
            
            Text(viewModel.shopInfo.description)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.light)
        }.padding(.horizontal, 10)
    }
    var Location : some View {
        VStack {
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
            HStack {
                Text("Location")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                Spacer()
                if !viewModel.invalidLocation {
                    Button {
                        // Open Map
                        if UIApplication.shared.canOpenURL(viewModel.mapLink!) {
                            UIApplication.shared.open(viewModel.mapLink!, options: [:], completionHandler: nil)
                        }
                    } label : {
                        HStack(spacing: 3) {
                            Text("Open in Map")
                                .fontWeight(.semibold)
                            Image(systemName: "arrowshape.turn.up.forward.fill")
                        }.font(.system(.footnote, design: .rounded))
                        .foregroundColor(.black)
                    }
                }
            }
            
            // Maps
            if viewModel.invalidLocation {
                Text("Sorry, We can't fetch location of store")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(
                        width : UIScreen.main.bounds.width * 0.95,
                        height : UIScreen.main.bounds.height * 0.15)
                    .background(
                        Image("tempMap")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Color.black.opacity(0.7))
                    )
                    .cornerRadius(20)
            } else {
                Map(coordinateRegion:  $viewModel.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .none,
                    annotationItems: viewModel.coor) { place in
                        MapMarker(coordinate: place.coordinate)
                    }
                    .frame(height : UIScreen.main.bounds.height * 0.15)
                    .cornerRadius(20)
            }
                
            // Address
            HStack {
                Spacer()
                Text(viewModel.shopInfo.location)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.medium)
                    .padding(.trailing, 10)
            }
        }.padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
    /*
    var Reviews : some View {
        VStack(alignment : .leading, spacing : 3) {
            HStack {
                Text("Reviews (\(viewModel.shopInfo.reviewCount))")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                Spacer()
                NavigationLink {
                    ReviewsView
                } label : {
                    Text("See more")
                        .font(.system(.footnote, design: .rounded))
                        .fontWeight(.semibold)
                }
            }.padding(.bottom, 5)
            
            ForEach(viewModel.reviews.prefix(3), id : \.self) { review in
                HStack {
                    Image(systemName : "person.fill")
                    Text(review.content).fontWeight(.light)
                }.padding(.leading, 10)
            }
        }.onAppear { viewModel.getReview() }
        .padding(.horizontal, 10)
    }
    */
    var ReviewsView : some View {
        VStack {
            // Title
            HStack {
                Text("Reviews (\(viewModel.shopInfo.reviewCount))")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                Spacer()
//                NavigationLink {
//                    //ReviewsView
//                } label : {
//                    Text("See more")
//                        .font(.system(.footnote, design: .rounded))
//                        .fontWeight(.semibold)
//                }
            }
            
            // Contents
            ForEach(viewModel.reviews, id : \.self) { review in
                HStack(spacing : 10) {
                    URLImage(
                        URL(string : review.member.profileImage) ??
                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }.frame(
                        width: UIScreen.main.bounds.width * 0.12,
                        height: UIScreen.main.bounds.width * 0.12)
                    .cornerRadius(10)
                    VStack(alignment : .leading, spacing : 5) {
                        HStack {
                            Text(review.member.username)
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.semibold)
                                .minimumScaleFactor(0.01)
                            Text(convertReturnedDateString(review.createdAt))
                                .font(.caption)
                                .fontWeight(.light)
                                .minimumScaleFactor(0.01)
                            Spacer()
                            
                            if memberId == review.member.memberId {
                                Button {
                                    viewModel.selectedReview = review.reviewId
                                    viewModel.showReviewAction = true
                                } label : {
                                    Image(systemName : "ellipsis")
                                }
                            }
                        }
                        Text(review.content)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                
                // 리뷰 수정
                if viewModel.isModifying && review.reviewId == viewModel.selectedReview {
                    HStack {
                        TextField("", text: $viewModel.modifyText)
                            .disableAutocorrection(true)
                            .padding(.horizontal, 10)
                            .frame(minWidth: UIScreen.main.bounds.width * 0.5, maxWidth: .infinity)
                            .frame(height : UIScreen.main.bounds.height * 0.04)
                            .background(Color.white)
                            .cornerRadius(10)
                        Button {
                            withAnimation {
                                viewModel.isModifying = false
                                viewModel.modifyReview()
                                viewModel.modifyText = ""
                            }
                        } label : {
                            Text("Done")
                                .fontWeight(.semibold)
                                .padding(5)
                                .padding(.vertical, 3)
                                .foregroundColor(.white)
                                .background(viewModel.modifyText.isEmpty ? Color.gray : Color.mainTheme)
                                .cornerRadius(10)
                        }.disabled(viewModel.modifyText.isEmpty)
                    }
                }
                
                Color.darkGray.opacity(0.1)
                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 3)
                    .cornerRadius(5)
                    .padding(.vertical, 3)
            }.onDisappear {
                viewModel.isModifying = false
                viewModel.modifyText = ""
            }
            
            // Button for load more
            if viewModel.reviews.count == 20 {
                Button {
                    viewModel.lastReviewId = viewModel.reviews.last?.reviewId ?? 0
                    viewModel.getReview()
                } label : {
                    Text("Load more")
                        .foregroundColor(.mainTheme)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.semibold)
                }
            }
        }.onAppear { viewModel.getReview() }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .background(Color.systemDefaultGray)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.6), radius: 2, x: 0, y: 2)
        .padding(.bottom, 15)
    }
    var AddReview : some View {
        HStack {
            TextField("", text: $viewModel.reviewText)
                .disableAutocorrection(true)
                .padding(.horizontal, 10)
                .frame(minWidth: UIScreen.main.bounds.width * 0.5, maxWidth: .infinity)
                .frame(height : UIScreen.main.bounds.height * 0.04)
                .background(Color.white)
                .cornerRadius(10)
            Button {
                viewModel.addReview()
                viewModel.reviewText = ""
            } label : {
                Text("Add Review")
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.semibold)
            }.padding(3)
            .padding(.vertical, 5)
            .background(viewModel.reviewText == "" ? Color.gray : Color.mainTheme)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.reviewText == "")
        }.padding()
        .foregroundColor(.gray)
        .background(Color.systemDefaultGray)
    }
    /*
    var CountingStars : some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation { viewModel.showAddReview = false }
                } label : {
                    Image(systemName : "xmark")
                        .foregroundColor(.mainTheme)
                        .font(.system(size : 20))
                        .padding(.trailing, 10)
                    
                }
            }
            URLImage(
                URL(string : viewModel.shopImage) ??
                URL(string: "https://static.thenounproject.com/png/741653-200.png")!
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }.frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
            .cornerRadius(20)
           
            Text(viewModel.shopInfo.name)
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
            
            ZStack {
                HStack(spacing : 0) {
                    ForEach(1...5, id: \.self) { _ in
                        Rectangle()
                            .frame(width : 40, height : 40)
                            .foregroundColor(.systemDefaultGray)
                            .overlay(
                                Image(systemName: "star.fill")
                                    .font(.system(size : 30))
                                    .foregroundColor(.mainTheme)
                            )
                    }
                }
                HStack(spacing : 0) {
                    ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], id: \.self) { i in
                        Rectangle()
                            .frame(width : 20, height : 40)
                            .foregroundColor(.systemDefaultGray)
                            .opacity(viewModel.reviewRate - Float(i) * 0.5 > 0 ? 0 : 1 )
                    }
                }
                HStack(spacing : 0) {
                    ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], id: \.self) { i in
                        Rectangle()
                            .frame(width : 20, height : 40)
                            .foregroundColor(.systemDefaultGray.opacity(0.00001))
                            .onTapGesture {
                                viewModel.reviewRate = Float(i + 1) * 0.5
                            }

                    }
                }
            }
 
            TextField("Review", text: $viewModel.reviewText)
                .lineLimit(2)
                .frame(width : UIScreen.main.bounds.width * 0.6)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button {
                viewModel.addReview()
                viewModel.showAddReview = false
            } label : {
                Text("Add Review")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.mainTheme)
                    .cornerRadius(20)
            }
        }.zIndex(5)
        .frame(width : UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.4)
        .background(Color.systemDefaultGray)
        .cornerRadius(15)
    }
    */
    
    var body: some View {
        VStack(spacing : 0) {
            ScrollView {
                StoreImages
                Title
                Location
                ReviewsView
            }
            if !viewModel.isModifying { AddReview }
        }
        .navigationTitle(Text(viewModel.shopInfo.name))
        .actionSheet(isPresented: $viewModel.showReviewAction) {
            ActionSheet(title: Text("Review"),
                        buttons: [
                            .default(Text("Modify Review"), action: {
                                //print("modify \(viewModel.selectedReview)")
                                //viewModel.modifyReview()
                                withAnimation { viewModel.isModifying = true }
                            }),
                            .destructive(Text("Delete Review"), action: {
                                //print("delete \(viewModel.selectedReview)")
                                viewModel.deleteReview()
                            }),
                            .cancel()
                        ]
            )
        }
        .alert(isPresented: $viewModel.addReviewDone) {
            Alert(title: Text("Add Review Done"),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}
