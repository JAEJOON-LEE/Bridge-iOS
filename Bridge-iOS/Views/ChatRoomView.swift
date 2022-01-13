//
//  ChatRoomView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import SwiftUI
import URLImage

struct ChatroomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : ChatroomViewModel
    
    @State private var offset = CGSize.zero
    @State private var ImageViewOffset = CGSize.zero
    
    let userWith : String
    
    init(viewModel : ChatroomViewModel, with user : String) {
        userWith = user
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing : 0) {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack {
                        ForEach(viewModel.MessageList.reversed(), id : \.self) { message in // reversed() -> 최신순
                            HStack {
                                if let user = message.member {
                                    if user.username == userWith { // 상대방이 보낸 메시지
                                        MessageBox(message.message)
                                        Spacer()
                                    } else { // 내가 보낸 메시지
                                        Spacer()
                                        MessageBox(message.message, mine : true)
                                    }
                                } else { // Anonymous 익명 메시지
                                    MessageBox(message.message)
                                    Spacer()
                                }
                            }.id(message.message.messageId)
                        } // ForEach
                    } // LazyVStack
                    .sheet(isPresented: $viewModel.showImagePicker) {
                        ImagePicker(image: $viewModel.selectedImage)
                    }
                    .onAppear {
                        viewModel.getChatContents(viewModel.chatId)
                        proxy.scrollTo(viewModel.lastMessageId)
                    }
                    .onChange(of: viewModel.lastMessageId) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.lastMessageId)
                        }
                    }
                } // ScrollViewReader
            } // ScrollView
            .padding(.bottom, 2)
            
            if viewModel.selectedImage != nil {
                HStack {
                    Spacer()
                    Text("Selected Image")
                        .font(.headline)
                        .onTapGesture { viewModel.showSelectedImage.toggle() }
                    Spacer()
                    Button{
                        withAnimation { viewModel.selectedImage = nil }
                    } label : {
                        Image(systemName : "xmark.circle")
                            .font(.system(size : 16))
                    }
                }.foregroundColor(.systemDefaultGray)
                .padding()
                .background(Color.black.opacity(0.5))
            }
            // Text Bar
            HStack {
                Button {
                    viewModel.showImagePicker = true
                } label : {
                    Image(systemName : "camera")
                }
                
                TextField("", text: $viewModel.messageText)
                    .padding(.horizontal, 10)
                    .frame(minWidth: UIScreen.main.bounds.width * 0.5, maxWidth: .infinity)
                    .frame(height : UIScreen.main.bounds.height * 0.04)
                    .background(Color.white)
                    .cornerRadius(10)
                Button {
                    print("Publish message " + viewModel.messageText)
                    
                    // MESSAGE PUBLISHING
                    //viewModel.stompManager.sendMessage(message: text)
                    
                    let newMsg = Message(
                        member:
                            Sender(
                                memberId: viewModel.userInfo.memberId,
                                username: viewModel.userInfo.username,
                                description: viewModel.userInfo.description,
                                profileImage: viewModel.userInfo.profileImage
                            ),
                        message:
                            MessageContents(
                                messageId: viewModel.lastMessageId + 1,
                                message: viewModel.messageText,
                                image: "null",
                                createdAt: "\(Date(timeIntervalSinceNow: 32400))"
                            )
                    )
                    //viewModel.MessageList.append(newMsg)
                    viewModel.lastMessageId += 1
                    viewModel.MessageList.insert(newMsg, at: viewModel.MessageList.startIndex)
                    viewModel.messageText = ""
                    viewModel.selectedImage = nil
                } label : {
                    Image(systemName : "arrow.up")
                        .padding(10)
                        .frame(height : UIScreen.main.bounds.height * 0.04)
                        .background(viewModel.messageText.count == 0 ? Color.white : Color.mainTheme)
                        .foregroundColor(viewModel.messageText.count == 0 ? .gray : .white)
                        .cornerRadius(20)
                }.disabled(viewModel.messageText == "")
            }
            .padding()
            .foregroundColor(.gray)
            .background(Color.systemDefaultGray)
        } // VStack
        //.edgesIgnoringSafeArea(.bottom)
        .navigationTitle(Text(userWith))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button {
                    viewModel.toolbarButtonClicked = true
                } label : {
                    Image(systemName: "ellipsis")
                }
        )
        .actionSheet(isPresented: $viewModel.toolbarButtonClicked) {
            ActionSheet(title: Text("More Action"),
                        buttons:
                            [
                                //.default(Text("Exit Room")) { print("Exit chat room") },
                                .destructive(Text("Exit Room")) {
                                    viewModel.toolbarButtonClickedConfirm = true
                                },
                                .cancel()
                            ]
            )
        }
        .alert(isPresented: $viewModel.toolbarButtonClickedConfirm) {
            Alert(title: Text("Do you really want to Exit?"),
                  primaryButton: .destructive(Text("Yes")) {
                                    print("Exit chat room \(viewModel.chatId)")
                                    viewModel.exitChat() // API Calling
                                    presentationMode.wrappedValue.dismiss()
                                  },
                  secondaryButton: .cancel(Text("No"))
            )
        }
        .fullScreenCover(isPresented: $viewModel.showSelectedImage) {
            ZStack(alignment : .topTrailing) {
                VStack {
                    Spacer()
                    Image(uiImage: viewModel.selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width : UIScreen.main.bounds.width)
                        .offset(x : 0, y : ImageViewOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if -50 < gesture.translation.height && gesture.translation.height < 100 {
                                        self.ImageViewOffset = gesture.translation
                                    } else if gesture.translation.height >= 100 {
                                        viewModel.showSelectedImage.toggle()
                                        self.ImageViewOffset = .zero
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        self.ImageViewOffset = .zero
                                    }
                                }
                        )
                    Spacer()
                }
                
                VStack {
                    Button {
                        viewModel.showSelectedImage.toggle()
                    } label : {
                        Image(systemName : "xmark")
                            .foregroundColor(.mainTheme)
                            .font(.system(size : 20))
                            .padding()
                    }
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height * 0.9)
            }
        }
    }
}

// Each line of Message
struct MessageBox : View {
    var message : MessageContents
    var mine : Bool = false
    
    init(_ message : MessageContents) {
        self.message = message
    }
    init(_ message : MessageContents, mine : Bool) {
        self.message = message
        self.mine = mine
    }
    
    var body : some View {
        VStack(alignment : mine ? .trailing : .leading, spacing : 3) {
            VStack(alignment : .trailing) {
                // -- message w/o image
                if message.message != "" {
                    Text(message.message)
                }
                // -- message w/ image
                if message.image != "null" {
                    URLImage(
                        URL(string : message.image)!
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth : UIScreen.main.bounds.width * 0.6)
                    }.cornerRadius(10)
                }
//                내가 보낸 이미지 메시지 처리 방식 !!
//                else if message.image == "localImage" {
//                    Image()
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth : UIScreen.main.bounds.width * 0.6)
//                        .cornerRadius(10)
//                }
            }
            .padding()
            .background(mine ? Color.mainTheme : Color.systemDefaultGray)
            .cornerRadius(10)
        
            Text(convertReturnedDateString(message.createdAt))
                .foregroundColor(.black.opacity(0.7))
                .font(.system(size : 10))
        }.padding(.horizontal, 10)
    }
}
