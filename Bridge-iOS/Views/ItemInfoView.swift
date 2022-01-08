//
//  SwiftUIView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import SwiftUI
import URLImage

struct ItemInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : ItemInfoViewModel
    @State var isModifyDone : Bool = false
    @State private var offset = CGSize.zero
    @State private var ImageViewOffset = CGSize.zero
    
    init(viewModel : ItemInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Image Area
            VStack {
                TabView(selection : $viewModel.currentImageIndex) {
                    ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) { imageInfo in
                        URLImage(
                            URL(string : imageInfo.image) ??
                            URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .tag(imageInfo.imageId)
                        .onTapGesture {
                            viewModel.currentImageIndex = imageInfo.imageId
                        }
                    }
                }.tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3 + offset.height)
                Spacer()
            }.blur(radius: viewModel.isMemberInfoClicked ? 5 : 0)
            .onTapGesture {
                viewModel.isImageTap.toggle() // 이미지 확대 보기 기능
            }
            .fullScreenCover(isPresented: $viewModel.isImageTap, content: {
                ZStack(alignment : .topTrailing) {
                    TabView(selection : $viewModel.currentImageIndex) {
                        ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) { imageInfo in
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
                    .offset(x : 0, y : ImageViewOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if -50 < gesture.translation.height && gesture.translation.height < 100 {
                                    self.ImageViewOffset = gesture.translation
                                } else if gesture.translation.height >= 100 {
                                    viewModel.isImageTap.toggle()
                                    self.ImageViewOffset = .zero
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    self.ImageViewOffset = .zero
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
            })

            
            // Text Area
            VStack {
                Spacer()
                VStack(alignment : .leading) {
                    // Title
                    HStack {
                        VStack(alignment : .leading, spacing: 10) {
                            Text(viewModel.itemInfo?.usedPostDetail.title ?? "Title not found")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                            HStack(spacing : 5) {
                                Text(convertReturnedDateString(viewModel.itemInfo?.usedPostDetail.createdAt ?? "2021-10-01 00:00:00"))
                                Text("|").foregroundColor(.mainTheme)
                                Text("\(viewModel.itemInfo?.usedPostDetail.viewCount ?? 0) View")
                                Text("|").foregroundColor(.mainTheme)
                                Text("\(viewModel.itemInfo?.usedPostDetail.likeCount ?? 0) Likes")
                            }.font(.system(size : 11, weight : .semibold))
                        }.foregroundColor(.black.opacity(0.8))
                        Spacer()
                        HStack(spacing : 5) {
                            Text("$")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text(viewModel.formattedPrice)
                                .foregroundColor(.mainTheme)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                    }

                    
                    // User Area
                    HStack {
                        URLImage(
                            URL(string: viewModel.itemInfo?.member.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(15)
                        
                        VStack(alignment : .leading, spacing: 5) {
                            Text(viewModel.itemInfo?.member.username ?? "Unknown")
                                .fontWeight(.semibold)
                            Text(viewModel.itemInfo?.member.description ?? "Error occur")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button {
                            withAnimation { viewModel.isMemberInfoClicked = true }
                        } label : {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding(8)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .padding(.trailing, 5)
                        }
                    }
                    .padding(5)
                    .background(Color.systemDefaultGray)
                    .cornerRadius(15)
                    .shadow(radius: 1)
                    .padding(.bottom, 10)
                    
                    // Camp Info
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(viewModel.itemInfo?.usedPostDetail.camps ?? [], id : \.self) { camp in
                                Text(camp)
                                    .foregroundColor(.mainTheme)
                                    .font(.system(size : 12, weight : .semibold))
                                    .padding(6)
                                    .background(Color.systemDefaultGray)
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                                    .padding(.leading, 2)
                            }
                        }.frame(height : 30)
                    }

                    Divider()
                        .padding(.vertical, 3)
                    
                    // Item Desc.
                    VStack(alignment : .leading, spacing: 10) {
                        HStack {
                            Text("About Item")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.mainTheme)
                            Text("#\(viewModel.itemInfo?.usedPostDetail.category ?? "etc.")")
                                .foregroundColor(.darkGray)
                                .font(.system(size : 12, weight : .semibold))
                                .padding(6)
                                .background(Color.systemDefaultGray)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.leading, 2)
                            Spacer()
                            if viewModel.isMyPost {
                                Button { viewModel.showAction = true } label : {
                                    Image(systemName : "ellipsis")
                                        .foregroundColor(.black)
                                        .font(.system(size : 15, weight : .bold))
                                }
                            }
                        }
                        Text(viewModel.itemInfo?.usedPostDetail.description ?? "error")
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button { } label : {
                            HStack {
                                Text("Knock Now!")
                                    .font(.system(size : 20, weight : .bold))
                                Image(systemName : "hand.wave.fill")
                                    .font(.system(size : 20, weight : .bold))
                            }
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08)
                            .background(Color.mainTheme)
                            .cornerRadius(30)
                        }
                        Spacer()
                    }
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.04)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.57)
                .background(Color.systemDefaultGray)
                .cornerRadius(25)
            }
            .offset(x: 0, y: offset.height)
            .edgesIgnoringSafeArea(.bottom)
            .shadow(radius: 5)
            .blur(radius: viewModel.isMemberInfoClicked ? 5 : 0)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        //if -50 < gesture.translation.height && gesture.translation.height < 100 {
                        if 0 < gesture.translation.height && gesture.translation.height < 100 {
                            self.offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            self.offset = .zero
                        }
                    }
            )
            
            // Seller Information
            if viewModel.isMemberInfoClicked {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation { viewModel.isMemberInfoClicked = false }
                        } label : {
                            Image(systemName: "xmark.circle")
                                .font(.system(size : 20, weight : .bold))
                                .foregroundColor(.white)
                        }.padding()
                    }.frame(height: 50)
                    
                    URLImage(
                        URL(string : viewModel.itemInfo?.member.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                    .shadow(radius: 5)
                    
                    Text(viewModel.itemInfo?.member.username ?? "Unknown UserName")
                        .font(.system(size : 20, weight : .bold))
                        .foregroundColor(.white)
                    Text("\"" + (viewModel.itemInfo?.member.description  ?? "User not found") + "\"")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(width : UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 1/3)
                .background(Color.mainTheme)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
        }
        .onChange(of: self.isModifyDone, perform: { _ in
            self.presentationMode.wrappedValue.dismiss()
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                Button {
                    if viewModel.isLiked! {
                        viewModel.itemInfo?.usedPostDetail.likeCount -= 1
                    } else {
                        viewModel.itemInfo?.usedPostDetail.likeCount += 1
                    }
                    viewModel.isLiked?.toggle()
                    viewModel.likePost(isliked: !(viewModel.isLiked ?? false))
                } label: {
                    if !viewModel.isMyPost {
                        Image(systemName: (viewModel.isLiked ?? true) ? "heart.fill" : "heart")
                            .font(.system(size : 15, weight : .bold))
                            .foregroundColor(.black)
                    }
                }
        )
        .actionSheet(isPresented: $viewModel.showAction) {
            ActionSheet(
                title: Text("Post Options"),
                buttons: [
                    .default(Text("Modify Post")) { viewModel.showPostModify = true },
                    .destructive(Text("Delete Post")) { viewModel.showConfirmDeletion = true },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $viewModel.showConfirmDeletion) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Do you want to delete this item?"),
                primaryButton: .destructive(Text("Yes"), action : {
                    viewModel.deletePost()
                    self.presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel(Text("No")))
        }
//        .fullScreenCover(isPresented: $viewModel.showPostModify, content: {
//            NavigationView {
//                ModifyUsedPostView(
//                    viewModel: ModifyUsedPostViewModel(
//                        accessToken : viewModel.token,
//                        postId : viewModel.postId,
//                        contents: viewModel.itemInfo!.usedPostDetail
//                    ),
//                    isModifyDone : self.$isModifyDone
//                )
//            }
//        })
        .sheet(isPresented: $viewModel.showPostModify, content: {
            NavigationView {
                ModifyUsedPostView(
                    viewModel: ModifyUsedPostViewModel(
                        accessToken : viewModel.token,
                        postId : viewModel.postId,
                        contents: viewModel.itemInfo!.usedPostDetail
                    ),
                    isModifyDone : self.$isModifyDone
                )
            }
        })
    }
}
