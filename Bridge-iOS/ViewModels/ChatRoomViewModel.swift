//
//  ChatRoomViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import StompClientLib

class ChatroomViewModel : ObservableObject {
    @Published var MessageList : [Message] = []
    @Published var lastMessageId : Int64 = 0
    @Published var messageText : String = ""
    @Published var selectedImage : UIImage? = nil
    @Published var showImagePicker : Bool = false
    @Published var showSelectedImage : Bool = false
    @Published var toolbarButtonClicked : Bool = false
    @Published var toolbarButtonClickedConfirm : Bool = false
    @Published var idForLoadMore : Int64 = 0
    
    private var subscription = Set<AnyCancellable>()
    
    // Socket Client instance
    var socketClient = StompClientLib()

    // Socket Connection URL
    private let url = URL(string: "ws://3.36.233.180:8080/stomp/chat/websocket")!

    let chatId : Int
    let userInfo : SignInResponse
    
    // init 시점 : ChatView load 될때
    init(_ chatId : Int, userInfo : SignInResponse) {
        self.chatId = chatId
        self.userInfo = userInfo
        
        //stompManager = StompManager(chatId, token: token)
    }
    
    // Socket Connection
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url), // as URL),
            delegate: self,
            connectionHeaders: [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
                            // , "heart-beat": "0,10000" ]
        )
    }
    
    // Subscribe
    func subscribe() {
        //socketClient.subscribe(destination: "/sub/chat/room/"  + chatId)
        
        let destination : String = "/sub/chat/room/\(chatId)"//  + chatId
        let ack = "ack_\(destination)" // It can be any unique string
        let subsId = "subscription_\(destination)" // It can be any unique string
        let header = ["destination": destination, "ack": ack, "id": subsId]

        socketClient.subscribeWithHeader(destination: destination, withHeader: header)
        print("Subscribe topic - /sub/chat/room/\(chatId)")// + chatId)
        //print("-- Subscribe with header : ")
        //print(header)
        
        //payloadObject["chatId"] = "\(chatId)"
    }
    
    // Publish Message
    func sendMessage() {
        let payloadObject : [String : Any] = [
            "memberId" : userInfo.memberId,
            "chatId" : chatId,
            "message" : messageText,
            //"image" : "null",
            "accessToken" : SignInViewModel.accessToken
        ]
//        payloadObject["message"] = message
//        payloadObject["image"] = "null"
//        payloadObject["accessToken"] = accessToken
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/pub/chat/message")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
    
    func getChatContents(_ chatId : Int) {
        let header : HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        let url = "http://3.36.233.180:8080/chats/\(chatId)/messages?lastMessageId=\(idForLoadMore)"
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            //.responseJSON{ json in print(json) }
            .publishDecodable(type : ChatContents.self)
            .compactMap { $0.value }
            .map { $0.messageList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Chat Contents Finished")
                }
            } receiveValue: { [weak self] (receivedValue : [Message]) in
                //print(receivedValue)
                //self?.MessageList = receivedValue.reversed()
                if let lastMsg = receivedValue.last?.message { self?.idForLoadMore = lastMsg.messageId }
                self?.MessageList.insert(contentsOf: receivedValue.reversed(), at: 0)

                if !receivedValue.isEmpty { self?.lastMessageId = receivedValue[0].message.messageId }
            }.store(in: &subscription)
    }

    func checkChatDay(index : Int) -> Bool {
        if index == 0 { return true }
        else {
            if convertReturnedDateStringToDay(MessageList[index].message.createdAt) == convertReturnedDateStringToDay(MessageList[index - 1].message.createdAt) {
                return false
            } else { return true }
        }
    }
    
    func checkChatTime(index : Int) -> Bool {
        if index == MessageList.count - 1 { return true }
        else {
            if convertReturnedDateStringTime(MessageList[index].message.createdAt) == convertReturnedDateStringTime(MessageList[index + 1].message.createdAt) {
                return false
            } else { return true }
        }
    }
    
    func exitChat() {
        let url = "http://3.36.233.180:8080/chats/\(chatId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in print(json) }
    }
}

// Delegate - CALLBACK Functions
extension ChatroomViewModel : StompClientLibDelegate {
    // didReceiveMessageWithJSONBody ( Message Received via STOMP )
    func stompClient(
            client: StompClientLib!,
            didReceiveMessageWithJSONBody jsonBody: AnyObject?,
            akaStringBody stringBody: String?,
            withHeader header: [String : String]?,
            withDestination destination: String
        ) {
            print("DESTINATION : \(destination)")
            print("HEADER : \(header ?? ["nil":"nil"])")
            print("JSON BODY : \(String(describing: jsonBody))")
            //print("String Body : \(stringBody ?? "nil")")
    }
    
    // didReceiveMessageWithJSONBody ( Message Received via STOMP as String )
    func stompClientJSONBody(
            client: StompClientLib!,
            didReceiveMessageWithJSONBody jsonBody: String?,
            withHeader header: [String : String]?,
            withDestination destination: String
        ) {
          print("DESTINATION : \(destination)")
          print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    // Unsubscribe Topic
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket \(chatId) is disconnected")
    }
    
    // Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket \(chatId) is connected")
    
        subscribe()
        // -> register 랑 subscribe 분리
    }
    
    // Error - disconnect and reconnect socket
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error send : " + description)
        
        socketClient.disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
}
