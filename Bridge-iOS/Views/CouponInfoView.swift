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
        HStack(spacing: 3) {
            VStack(alignment : .leading, spacing : 10) {
                Text(viewModel.shopInfo.name)
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                Text(viewModel.shopInfo.description)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.light)
            }
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(.mainTheme)
                .font(.system(size: 22))
            Text("\(viewModel.shopInfo.rate, specifier: "%.1f")(\(viewModel.shopInfo.reviewCount))")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
        }.padding(.horizontal, 10)
    }
    var Location : some View {
        VStack {
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
                        
                        // Temp value for test
                        //viewModel.region.center.latitude = 35.868847
                        //viewModel.region.center.longitude = 128.597108
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
            
            if viewModel.invalidLocation {
                Text("Sorry, We can't fetch store location")
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
                
            HStack {
                Spacer()
                Text(viewModel.shopInfo.location)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.light)
                    .padding(.trailing, 10)
            }
        }.padding(.horizontal, 10)
    }
    var ReviewsView : some View {
        ScrollView {
            VStack {
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
                        Image(systemName: "star.fill")
                            .foregroundColor(.mainTheme)
                        Text("\(review.rate, specifier: "%.1f")")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                    }.padding(.horizontal, 20)
                    
                    Color.systemDefaultGray
                        .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                        .padding(.vertical, 5)
                }
            }
        }.navigationTitle(Text("Reviews"))
    }
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
                    ForEach(viewModel.rateArray, id: \.self) { i in
                        Rectangle()
                            .frame(width : 20, height : 40)
                            .foregroundColor(.systemDefaultGray)
                            .opacity(viewModel.reviewRate - Double(i) * 0.5 > 0 ? 0 : 1 )
                    }
                }
                HStack(spacing : 0) {
                    ForEach(viewModel.rateArray, id: \.self) { i in
                        Rectangle()
                            .frame(width : 20, height : 40)
                            .foregroundColor(.systemDefaultGray.opacity(0.00001))
                            .onTapGesture {
                                viewModel.reviewRate = Double(i + 1) * 0.5
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
        .shadow(radius: 5)
    }
    
    var body: some View {
        ZStack {
            VStack {
                StoreImages
                Title
                Color.systemDefaultGray
                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                Location
                Color.systemDefaultGray
                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                
                // Review
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
                        }
                    }.padding(.bottom, 5)
                    
                    ForEach(viewModel.reviews.prefix(3), id : \.self) { review in
                        HStack {
                            Image(systemName : "person.fill")
                            Text(review.content).fontWeight(.light)
                        }.padding(.leading, 10)
                    }
                
                    // Add Review Btn
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation { viewModel.showAddReview = true }
                        } label : {
                            HStack {
                                Image(systemName: "pencil.circle")
                                Text("Add Review")
                                    .fontWeight(.semibold)
                            }.padding(7)
                            .background(Color.mainTheme)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                    }
                    Spacer()
                }.onAppear { viewModel.getReview() }
                .padding(.horizontal, 10)
            }.padding()
            .navigationTitle(Text(viewModel.shopInfo.name))
            .actionSheet(isPresented: $viewModel.showReviewAction) {
                ActionSheet(title: Text("Review"),
                            buttons: [
                                .default(Text("Modify Review"), action: {
                                    //print("modify \(viewModel.selectedReview)")
                                    viewModel.modifyReview()
                                }),
                                .destructive(Text("Delete Review"), action: {
                                    //print("delete \(viewModel.selectedReview)")
                                    viewModel.deleteReview()
                                }),
                                .cancel()
                            ]
                )
            }
            .overlay(Color.black.opacity(viewModel.showAddReview ? 0.7 : 0).edgesIgnoringSafeArea(.all))
         
            if viewModel.showAddReview { CountingStars }
        }
    }
}
