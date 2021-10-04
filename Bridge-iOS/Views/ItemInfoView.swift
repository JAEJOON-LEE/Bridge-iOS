//
//  SwiftUIView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import SwiftUI
import URLImage

struct ItemInfoView: View {
    @StateObject private var viewModel : ItemInfoViewModel
    
    init(viewModel : ItemInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Image Area
            VStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) { imageInfo in
                        URLImage(
                            URL(string : imageInfo.image) ??
                            URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.42)
                    }
                }
                Spacer()
            }
            
            // Text Area
            VStack {
                Spacer()
                VStack(alignment : .leading) {
                    // Title
                    HStack {
                        VStack(alignment : .leading, spacing: 10) {
                            Text((viewModel.itemInfo?.usedPostDetail.title)!)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            HStack{
                                Text("time")
                                Text("| \((viewModel.itemInfo?.usedPostDetail.viewCount)!) View")
                                Text("| \((viewModel.itemInfo?.usedPostDetail.likeCount)!) Likes")
                            }.font(.system(size : 13))
                        }
                        Spacer()
                        Text("$ " + String(format: "%.1f", (viewModel.itemInfo?.usedPostDetail.price)!))
                            .font(.largeTitle)
                    }
                    
                    // User Area
                    HStack {
                        URLImage(URL(string: viewModel.itemInfo?.member.profileImage ?? "")!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        
                        VStack(alignment : .leading, spacing: 5) {
                            Text((viewModel.itemInfo?.member.username)!).fontWeight(.semibold)
                            Text((viewModel.itemInfo?.member.description)!)
                        }
                        Spacer()
                        Image(systemName: "i.circle.fill")
                            .font(.system(size: 20))
                    }
                    .padding(5)
                    .background(Color.systemDefaultGray)
                    .cornerRadius(15)
                    .shadow(radius: 1)
                    .padding(.bottom, 10)
                    
                    // Camp Info
                    Text("Camp list area")
                    
                    Divider()
                    
                    // Item Desc.
                    VStack(alignment : .leading, spacing: 10) {
                        Text("About Item")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.mainTheme)
                        Text(viewModel.itemInfo?.usedPostDetail.description ?? "error")
                    }
                    
                    Spacer()
                    // Knock button # TEMP
                    HStack {
                        Spacer()
                        Button { } label : {
                            Text("Knock Now!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.07)
                                .background(Color.mainTheme)
                                .cornerRadius(25)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.5)
                .background(Color.systemDefaultGray)
                .cornerRadius(25)
            }
            .edgesIgnoringSafeArea(.bottom)
            .shadow(radius: 5)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
//
//struct ItemInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemInfoView()
//    }
//}
