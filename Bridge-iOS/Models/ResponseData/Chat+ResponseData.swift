//
//  Chat+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/05.
//

import Foundation

struct CreateChat : Codable {
    var chatId : Int
}

struct Chats : Codable {
    var chatList : [Chat]
}

struct Chat : Codable, Hashable {
    var chatId : Int
    var memberFrom : ChatMember? // ChatSender
    var memberTo : ChatMember? // ChatReceiver
    var message : ChatLast? // Last Chatted message
    var post : ChatAbout
}

struct ChatMember : Codable, Hashable {
    var memberId : Int
    var username : String
    var description : String
    var profileImage : String
}

struct ChatLast : Codable, Hashable {
    var messageId : Int
    var message : String?
    var image : String
    var createdAt : String
}

struct ChatAbout : Codable, Hashable {
    var postId : Int
    var image : String
//    var postType : String
//    var title : String
}

//struct ChatSender : Codable {
//    var memberId : Int
//    var username : String
//    var description : String
//    var profileImage : String
//}

//struct ChatReceiver : Codable {
//    var memberId : Int
//    var username : String
//    var description : String
//    var profileImage : String
//}
