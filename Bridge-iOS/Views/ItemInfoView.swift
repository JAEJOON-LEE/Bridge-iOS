//
//  SwiftUIView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import SwiftUI
import Kingfisher

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
        if !viewModel.isItemInfoFetchDone {
            VStack {
                Image("LOGO")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(5)
                ProgressView()
            }.edgesIgnoringSafeArea(.vertical)
            .frame(maxWidth : .infinity, maxHeight : .infinity)
            .onAppear{ viewModel.getItemInfo() }
        } else {
            ZStack {
                // Image Area
                VStack {
                    ZStack(alignment : .bottom) {
                        TabView(selection : $viewModel.currentImageIndex) {
                            ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) { imageInfo in
                                KFImage(URL(string : imageInfo.image) ??
                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!)
                                    .placeholder { ImagePlaceHolder() }
                                    .resizable()
                                    .fade(duration: 0.5)
                                    .aspectRatio(contentMode: .fill)
                                    .tag(imageInfo.imageId)
                                    .onTapGesture { viewModel.currentImageIndex = imageInfo.imageId }
                            }
                        }.tabViewStyle(PageTabViewStyle())
                        
                        TabView(selection : $viewModel.currentImageIndex) {
                            ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) {
                                Color.white.opacity(0)
                                    .tag($0.imageId)
                            }
                        }.frame(height : 40)
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .padding(.bottom, 40)
                    }.frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38 + offset.height)
                    Spacer()
                }.blur(radius: viewModel.isMemberInfoClicked ? 5 : 0)
                .onTapGesture { viewModel.isImageTap.toggle() } // ????????? ?????? ?????? ??????
                .fullScreenCover(isPresented: $viewModel.isImageTap, content: {
                    ZStack(alignment : .topTrailing) {
                        TabView(selection : $viewModel.currentImageIndex) {
                            ForEach(viewModel.itemInfo?.usedPostDetail.postImages ?? [], id : \.self) { imageInfo in
                                KFImage(URL(string : imageInfo.image) ??
                                        URL(string: "https://static.thenounproject.com/png/741653-200.png")!)
                                    .placeholder { ImagePlaceHolder() }
                                    .resizable()
                                    .fade(duration: 0.5)
                                    .aspectRatio(contentMode: .fit)
                                    .tag(imageInfo.imageId)
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
                                .onEnded { _ in withAnimation { self.ImageViewOffset = .zero } }
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
                        HStack(spacing: 10) {
                            VStack(alignment : .leading, spacing: 10) {
                                Text(viewModel.itemInfo?.usedPostDetail.title ?? "Title not found")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.4)
                                HStack(spacing : 5) {
                                    Text(convertReturnedDateString(viewModel.itemInfo?.usedPostDetail.createdAt ?? "2021-10-01 00:00:00"))
                                    Text("|").foregroundColor(.mainTheme)
                                    Text("\(viewModel.itemInfo?.usedPostDetail.viewCount ?? 0) View")
                                    Text("|").foregroundColor(.mainTheme)
                                    Text("\(viewModel.itemInfo?.usedPostDetail.likeCount ?? 0) Likes")
                                }.font(.system(size : 11, weight : .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
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
                            }.lineLimit(1)
                            .minimumScaleFactor(0.4)
                        }
                        
                        // User Area
                        HStack {
                            KFImage(URL(string: viewModel.itemInfo?.member.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
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
                        ScrollView(.horizontal, showsIndicators: false) {
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
                                    Button {
                                        viewModel.actionSheetType = 1
                                        viewModel.showAction = true
                                    } label : {
                                        Image(systemName : "ellipsis")
                                            .foregroundColor(.black)
                                            .font(.system(size : 15, weight : .bold))
                                    }
                                }
                            }
                            Text(viewModel.itemInfo?.usedPostDetail.description ?? "error")
                        }
                        
                        Spacer()
                        
                        if !viewModel.isMyPost {
                            HStack {
                                Spacer()
                                Button {
                                    viewModel.createChat()
                                } label : {
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
                        
                        KFImage(URL(string : viewModel.itemInfo?.member.profileImage ?? "https://static.thenounproject.com/png/741653-200.png")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                            .shadow(radius: 5)
                        
                        Text(viewModel.itemInfo?.member.username ?? "Unknown UserName")
                            .font(.system(size : 20, weight : .bold))
                            .foregroundColor(.white)
                        Text(viewModel.itemInfo?.member.description  ?? "User not found")
                            .foregroundColor(.white)
                        Spacer()
                        if !viewModel.isMyPost {
                            Button {
                                viewModel.actionSheetType = 2
                                viewModel.showAction = true
                            } label : {
                                Text("Block")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .padding(7)
                                    .frame(width : UIScreen.main.bounds.width * 0.3)
                                    .background(Color.red.opacity(0.5))
                                    .cornerRadius(20)
                            }
                            Spacer()
                        }
                    }
                    .zIndex(5)
                    .frame(width : UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 1/3)
                    .background(Color.mainTheme)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            //.onAppear{ viewModel.getItemInfo() }
            .onChange(of: self.isModifyDone) { _ in self.presentationMode.wrappedValue.dismiss() }
            .navigationBarTitle(Text(viewModel.itemInfo?.usedPostDetail.title ?? ""))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button {
                    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
                    hapticFeedback.impactOccurred()
                
                    if viewModel.isLiked ?? false { viewModel.itemInfo?.usedPostDetail.likeCount -= 1 }
                    else { viewModel.itemInfo?.usedPostDetail.likeCount += 1 }
                    viewModel.isLiked?.toggle()
                    viewModel.likePost(isliked: !(viewModel.isLiked ?? false))
                } label: {
                    if !viewModel.isMyPost {
                        Image(systemName: (viewModel.isLiked ?? true) ? "heart.fill" : "heart")
                            .font(.system(size : 15, weight : .bold))
                            .foregroundColor((viewModel.isLiked ?? true) ? .pink : .black)
                    }
                }
            )
            .actionSheet(isPresented: $viewModel.showAction) {
                if viewModel.actionSheetType == 1 {
                    return
                        ActionSheet(
                            title: Text("Post Options"),
                            buttons: [
                                .default(Text("Modify Post")) { viewModel.showPostModify = true },
                                .destructive(Text("Delete Post")) { viewModel.showConfirmDeletion = true },
                                .cancel()
                            ]
                        )
                } else { // viewModel.actionSheetType == 2 {
                    return ActionSheet(
                        title: Text("Do you want to block this user?"),
                        buttons: [
                            .destructive(Text("Block")) {
                                viewModel.blockUser()
                                withAnimation {
                                    viewModel.isMemberInfoClicked = false
                                }
                            },
                            .cancel()
                        ]
                    )
                }
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
            .sheet(isPresented: $viewModel.showPostModify, content: {
                NavigationView {
                    ModifyUsedPostView(viewModel:
                        ModifyUsedPostViewModel(
                            postId : viewModel.postId,
                            contents: viewModel.itemInfo!.usedPostDetail
                        ),
                       isModifyDone : self.$isModifyDone
                    )
                }
            })
            .sheet(isPresented: $viewModel.chatCreation) {
                NavigationView {
                    ChatroomView(viewModel:
                        ChatroomViewModel(viewModel.createdChatId,
                                          userInfo : viewModel.userInfo),
                            with: viewModel.itemInfo?.member.username ?? "Anonymous",
                            withId: viewModel.itemInfo?.member.memberId ?? 0,
                             isModal: true
                        )
                }
            }
//            .background(
//                NavigationLink(destination :
//                    ChatroomView(viewModel:
//                        ChatroomViewModel(viewModel.createdChatId,
//                                          userInfo : viewModel.userInfo),
//                            with: viewModel.itemInfo?.member.username ?? "Anonymous",
//                            withId: viewModel.itemInfo?.member.memberId ?? 0
//                        ),
//                    isActive : $viewModel.chatCreation
//                ) { }
//            )
        }
    }
}
