//
//  ChatRoomView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import SwiftUI
import Kingfisher

struct ChatroomView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : ChatroomViewModel
    
    @State private var offset = CGSize.zero
    @State private var ImageViewOffset = CGSize.zero
    
    let userWith : String
    let userIdWith : Int
    
    init(viewModel : ChatroomViewModel, with user : String, withId : Int) {
        userWith = user
        userIdWith = withId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing : 0) {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack {
                        Spacer().frame(height : 1)
                            .onAppear {
                                // Load more with last message id
                                print(viewModel.idForLoadMore)
                                viewModel.getChatContents(viewModel.chatId)
                            }
//                        Button {
//                            viewModel.getChatContents(viewModel.chatId)
//                        } label : {
//                            Text("Load more")
//                                .foregroundColor(.mainTheme)
//                        }
                        ForEach(0..<viewModel.MessageList.count, id : \.self) { index in
                            if viewModel.checkChatDay(index: index) {
                                Text(convertReturnedDateStringToDay(viewModel.MessageList[index].message.createdAt))
                                    .foregroundColor(.white)
                                    .font(.system(size : 13, design: .rounded))
                                    .padding(.horizontal)
                                    .background(Color.black.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(8)
                            }
                            
                            HStack {
                                if let user = viewModel.MessageList[index].member {
                                    if user.username == userWith { // 상대방이 보낸 메시지
                                        MessageBox(viewModel.MessageList[index].message,
                                                   time : viewModel.checkChatTime(index: index))
                                        Spacer()
                                    } else { // 내가 보낸 메시지
                                        Spacer()
                                        MessageBox(viewModel.MessageList[index].message,
                                                   mine : true,
                                                   time : viewModel.checkChatTime(index: index))
                                    }
                                } else { // Anonymous 익명 메시지
                                    MessageBox(viewModel.MessageList[index].message,
                                               time : viewModel.checkChatTime(index: index))
                                    Spacer()
                                }
                            }.id(viewModel.MessageList[index].message.messageId)
                            .padding(.bottom, viewModel.checkChatTime(index: index) ? 5 : -5)
                        } // ForEach
                    } // LazyVStack
                    .sheet(isPresented: $viewModel.showImagePicker) { ImagePicker(image: $viewModel.selectedImage).edgesIgnoringSafeArea(.bottom) }
                    .onAppear {
                        //viewModel.getChatContents(viewModel.chatId)
                        proxy.scrollTo(viewModel.lastMessageId)
                    }
                    .onChange(of: viewModel.lastMessageId) { _ in
                        withAnimation { proxy.scrollTo(viewModel.lastMessageId) }
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
                    viewModel.sendMessage()
                    
//                    let newMsg = Message(
//                        member:
//                            Sender(
//                                memberId: viewModel.userInfo.memberId,
//                                username: viewModel.userInfo.username,
//                                description: viewModel.userInfo.description,
//                                profileImage: viewModel.userInfo.profileImage
//                            ),
//                        message:
//                            MessageContents(
//                                messageId: viewModel.lastMessageId + 1,
//                                message: viewModel.messageText,
//                                image: "null",
//                                createdAt: "\(Date(timeIntervalSinceNow: 32400))"
//                            )
//                    )
//                    //viewModel.MessageList.append(newMsg)
//                    viewModel.lastMessageId += 1
//                    //viewModel.MessageList.insert(newMsg, at: viewModel.MessageList.startIndex)
//                    viewModel.MessageList.append(newMsg)
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
        .onAppear { viewModel.registerSockect() }
        .onDisappear { viewModel.disconnect() }
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
                                .destructive(Text("Block This User")) {
                                    viewModel.toolbarActionType = 2
                                    viewModel.showAlert = true
                                },
                                .destructive(Text("Exit Room")) {
                                    viewModel.toolbarActionType = 1
                                    viewModel.showAlert = true
                                },
                                .cancel()
                            ]
            )
        }
        .alert(isPresented: $viewModel.showAlert) {
            if viewModel.toolbarActionType == 1 { // Exit
                return
                    Alert(title: Text("Do you really want to Exit?"),
                      primaryButton: .destructive(Text("Yes")) {
                                        print("Exit chat room \(viewModel.chatId)")
                                        viewModel.exitChat() // API Calling
                                        presentationMode.wrappedValue.dismiss()
                                      },
                      secondaryButton: .cancel(Text("No"))
                    )
            } else { // viewModel.toolbarActionType == 2 // Block
                return
                    Alert(title: Text("Do you really want to Block this user?"),
                      primaryButton: .destructive(Text("Yes")) {
                                        print("Block user \(userIdWith)")
                                        viewModel.blockUser(userIdWith)
                                        viewModel.exitChat()
                                        presentationMode.wrappedValue.dismiss()
                                      },
                      secondaryButton: .cancel(Text("No"))
                    )
            }
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
    var time : Bool
    
    init(_ message : MessageContents, time : Bool) {
        self.message = message
        self.time = time
    }
    
    init(_ message : MessageContents, mine : Bool, time : Bool) {
        self.message = message
        self.mine = mine
        self.time = time
    }
    
    var body : some View {
        VStack(alignment : mine ? .trailing : .leading, spacing : 3) {
            HStack(spacing : 3) {
                if mine && time {
                    Text(convertReturnedDateStringTime(message.createdAt))
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size : 10, design: .rounded))
                        .padding(.top)
                }
                
                
                VStack(alignment : .trailing) {
                    // -- message w/o image
                    if message.message != "" {
                        Text(message.message)
                    }
                    // -- message w/ image
                    if message.image != "null" {
                        KFImage(URL(string : message.image)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth : UIScreen.main.bounds.width * 0.6)
                            .cornerRadius(10)
                    }
//                    내가 보낸 이미지 메시지 처리 방식 !!
//                    else if message.image == "localImage" {
//                        Image()
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(maxWidth : UIScreen.main.bounds.width * 0.6)
//                            .cornerRadius(10)
//                    }
                }
                .padding(10)
                .background(mine ? Color.mainTheme : Color.systemDefaultGray)
                .cornerRadius(15)
                
                if !mine && time {
                    Text(convertReturnedDateStringTime(message.createdAt))
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size : 10, design: .rounded))
                        .padding(.top)
                }
            }
        }.padding(.horizontal, 10)
    }
}
