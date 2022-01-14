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

    init(viewModel : CouponInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            // Title
            HStack(spacing : 20) {
                URLImage(
                    URL(string : viewModel.shopInfo.images[0].image) ??
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
            }
            
            Map(coordinateRegion:  $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: viewModel.coor) { place in
                MapMarker(coordinate: place.coordinate)
            }.frame(height : UIScreen.main.bounds.height * 0.2)
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
                    Image(systemName : "ellipsis")
                }
            }
            
            HStack {
                Color.systemDefaultGray
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .cornerRadius(10)
                Color.systemDefaultGray
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .cornerRadius(10)
                Color.systemDefaultGray
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    .cornerRadius(10)
            }
            
            Color.systemDefaultGray
                .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                .padding(.vertical, 5)
            
            VStack(alignment : .leading, spacing : 3) {
                HStack {
                    Text("Reviews (\(viewModel.shopInfo.reviewCount))")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        
                    } label : {
                        Image(systemName : "plus")
                    }
                    Button {
                        
                    } label : {
                        Image(systemName : "ellipsis")
                    }
                }.padding(.bottom, 5)
                
                Text("Review1")
                Text("Review2")
                Spacer()
            }
        }.padding()
    }
}
