//
//  ChatViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/05.
//

import Foundation
import Alamofire
import Combine

final class ChatViewModel : ObservableObject {
    @Published var ChatList : [Chat] = []
    @Published var searchText : String = ""
    
    private var subscription = Set<AnyCancellable>()
    
    private let url = baseURL + "/chats"
    let userInfo : SignInResponse
    let userId : Int
    
    init(userInfo : SignInResponse) {
        self.userInfo = userInfo
        userId = userInfo.memberId
        //getChats()
    }
    
    func getChats() {
        let header : HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            //.responseJSON{ json in print(json) }
            .publishDecodable(type : Chats.self)
            .compactMap { $0.value }
            .map { $0.chatList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Chats List Finished")
                }
            } receiveValue: { [weak self] receivedValue in
                self?.ChatList = receivedValue
                self?.ChatList.sort {
                    return $0.message?.createdAt ?? "" > $1.message?.createdAt ?? ""
                }
                //print(self?.ChatList)
            }.store(in: &subscription)
    }
    
    func chatWith(chatroom : Chat) -> ChatMember? {
        guard let memberTo = chatroom.memberTo, let memberFrom = chatroom.memberFrom else { return nil }
        
        if userId == memberTo.memberId { return memberFrom }
        else if userId == memberFrom.memberId { return memberTo }
        
        return nil
    }
}

