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
    
    var body: some View {
        VStack {
            // Title
            HStack(spacing : 20) {
                URLImage(
                    URL(string : viewModel.shopImage) ??
                    URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }.frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                .cornerRadius(20)
                VStack(alignment : .leading, spacing : 10) {
                    Text(viewModel.shopInfo.name)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.mainTheme)
                        Text("\(viewModel.shopInfo.rate, specifier: "%.1f") (\(viewModel.shopInfo.reviewCount))")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                    }
                    Text(viewModel.shopInfo.description)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.light)
                }
                Spacer()
            }
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
            
            HStack {
                Text("Location")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                Spacer()
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
            
            Map(coordinateRegion:  $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: viewModel.coor) { place in
                MapMarker(coordinate: place.coordinate)
            }
            .frame(height : UIScreen.main.bounds.height * 0.2)
            .cornerRadius(20)
            
            HStack {
                Spacer()
                Text("43, Garosu-gil, Gangnam-gu, Seoul, Republic of Korea") // place holder
                //Text(viewModel.shopInfo.location)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.light)
            }
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                .padding(.vertical, 3)
            
            HStack {
                Text("Photos (\(viewModel.shopInfo.images.count))")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    
                } label : {
                    Text("See more")
                }
            }
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(viewModel.shopInfo.images, id : \.self) { imageInfo in // .prefix(3)
                        URLImage(
                            URL(string : imageInfo.image) ??
                            URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }.frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                        .cornerRadius(10)
                    }
                }
            }
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                .padding(.vertical, 5)
            
            // Review
            VStack(alignment : .leading, spacing : 3) {
                HStack {
                    Text("Reviews (\(viewModel.shopInfo.reviewCount))")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                    Spacer()
                    NavigationLink {
                        ScrollView {
                            VStack {
                                ForEach(viewModel.reviews, id : \.self) { review in
                                    HStack(spacing : 20) {
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
            
                Spacer()
                // Add Review
                HStack {
                    Spacer()
                    Button {
                        viewModel.showAddReview = true
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
                }.sheet(isPresented: $viewModel.showAddReview) {
                    VStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.mainTheme)
                            Text("\(viewModel.reviewRate, specifier: "%.1f")")
                        }.font(.largeTitle)
                        
                        Slider(value: $viewModel.reviewRate, in: 0...5, step: 0.05)
                            .accentColor(.mainTheme)
                            .frame(width : UIScreen.main.bounds.width * 0.3)
                        TextField("Review", text: $viewModel.reviewText)
                            .lineLimit(2)
                            .frame(width : UIScreen.main.bounds.width * 0.8)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button {
                            viewModel.addReview()
                        } label : {
                            Text("Add Review")
                                .padding()
                                .background(Color.mainTheme)
                                .cornerRadius(20)
                        }
                    }
                }
                Spacer()
            }.onAppear { viewModel.getReview() }
        }.padding()
        .navigationTitle(Text(viewModel.shopInfo.name))
        .actionSheet(isPresented: $viewModel.showReviewAction) {
            ActionSheet(title: Text("Review"),
                        //message: <#T##Text?#>,
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
    }
}
