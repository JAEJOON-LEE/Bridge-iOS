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

final class ChatroomViewModel : ObservableObject {
    @Published var MessageList : [Message] = []
    @Published var lastMessageId : Int64 = 0
    @Published var messageText : String = ""
    @Published var selectedImage : UIImage? = nil
    @Published var showImagePicker : Bool = false
    @Published var showSelectedImage : Bool = false
    @Published var toolbarButtonClicked : Bool = false
    @Published var toolbarButtonClickedConfirm : Bool = false
    
    private var subscription = Set<AnyCancellable>()
    
    //var stompManager : StompManager
    
    let chatId : Int
    let userInfo : SignInResponse
    
    init(_ chatId : Int, userInfo : SignInResponse) {
        self.chatId = chatId
        self.userInfo = userInfo
        
        //stompManager = StompManager(chatId, token: token)
    }
    
    func getChatContents(_ chatId : Int) {
        let header : HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        let url = "http://3.36.233.180:8080/chats/\(chatId)/messages?lastMessageId=0"
        
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
                self?.MessageList = receivedValue
                if !receivedValue.isEmpty { self?.lastMessageId = receivedValue[0].message.messageId }
            }.store(in: &subscription)
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

