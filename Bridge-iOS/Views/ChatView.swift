//
//  ChatView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/05.
//

import SwiftUI
import URLImage

struct ChatView: View {
    @StateObject private var viewModel : ChatViewModel
    
    init(viewModel : ChatViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            // SearchBar
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal, 3)
                TextField("Search", text: $viewModel.searchText)
                    .autocapitalization(.none)
                    .font(.system(size : 14))
                Spacer()
            }
            .foregroundColor(.gray)
            .frame(width: UIScreen.main.bounds.width * 0.95, height : UIScreen.main.bounds.height * 0.035)
            .background(Color.systemDefaultGray)
            .cornerRadius(15)
            .padding(.vertical, 3)
            
            // Chat list
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.ChatList.filter{ chatroom in
                        guard let userName = viewModel.chatWith(chatroom: chatroom)?.username else {
                            if viewModel.searchText.isEmpty { return true }
                            else { return false }
                        }
                        return viewModel.searchText.isEmpty || userName.lowercased().contains(viewModel.searchText.lowercased())
                    }, id : \.self
                    ) { chatroom in
                        if chatroom.message != nil { // chat room with no message
                            
                            VStack {
                                NavigationLink(destination :
                                                ChatroomView(viewModel: ChatroomViewModel(chatroom.chatId,
                                                                                         userInfo : MemeberInformation(
                                                                                                memberId: viewModel.userInfo.memberId,
                                                                                                username: viewModel.userInfo.username,
                                                                                                description: viewModel.userInfo.description,
                                                                                                profileImage: viewModel.userInfo.profileImage,
                                                                                                chatAlarm: false,
                                                                                                playgroundAlarm: false,
                                                                                                usedAlarm: false)),
                                                             with : viewModel.chatWith(chatroom: chatroom)?.username ?? "Anonymous",
                                                             withId : viewModel.chatWith(chatroom: chatroom)?.memberId ?? 0
                                                            )
                                ) {
                                    HStack {
                                        // 1. Profile Image
                                        URLImage(
                                            URL(string : viewModel.chatWith(chatroom: chatroom)?.profileImage ?? "https://www.gravatar.com/avatar/3b37be7c3ac00a1237fe8d4252fd4540.jpg?size=240&d=https%3A%2F%2Fwww.artstation.com%2Fassets%2Fdefault_avatar.jpg")!
                                        ) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                        .frame(
                                            width : UIScreen.main.bounds.width * 0.16,
                                            height: UIScreen.main.bounds.width * 0.16
                                        )
                                        .clipShape(Circle())
                                        .padding(.horizontal, 5)
                                        
                                        // 2. Text Area
                                        VStack(alignment : .leading, spacing : 5) {
                                            Text(viewModel.chatWith(chatroom: chatroom)?.username ?? "Anonymous")
                                                .font(.system(size: 18, weight : .bold, design : .rounded))
                                                .foregroundColor(.black)
                                            
                                            if let msg = chatroom.message {
                                                Text(msg.message.isEmpty ? "📷 Image" : msg.message)
                                                    .lineLimit(1)
                                                    .font(.system(size: 13, weight : .bold, design : .rounded))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text(convertReturnedDateString(chatroom.message?.createdAt ?? "2021-10-01 00:00:00"))
                                                .font(.system(.caption, design : .rounded))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        
                                        Spacer()
                                        
                                        // 3. PostImage
                                        URLImage(
                                            URL(string : chatroom.post.image)!
                                        ) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        }
                                        .frame(
                                            width : UIScreen.main.bounds.width * 0.25,
                                            height: UIScreen.main.bounds.width * 0.2
                                        )
                                        .cornerRadius(20)
                                    }
                                    .frame(width : UIScreen.main.bounds.width * 0.95)
                                    .padding(10)
                                    .padding(.horizontal, 5)
                                }

                                Color.systemDefaultGray
                                    .frame(width : UIScreen.main.bounds.width * 0.9, height : 5)
                            } // VStack
                            
                        } // if
                    } // ForEach
                    Spacer().frame(height : UIScreen.main.bounds.height * 0.1)
                } // LazyVStack
            } // ScrollView
        }
        .overlay(
            VStack(spacing : 0) {
                Spacer()
                LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom)
                    .frame(height : UIScreen.main.bounds.height * 0.1)
                Color.white
                    .frame(height : UIScreen.main.bounds.height * 0.05)
            }.edgesIgnoringSafeArea(.bottom)
        )
        .onAppear {
            viewModel.getChats()
        }
    }
}
