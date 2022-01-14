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
    
    private let url = "http://3.36.233.180:8080/chats"
    let userInfo : SignInResponse
    
    init(userInfo : SignInResponse) {
        self.userInfo = userInfo
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
                //print(self?.ChatList)
            }.store(in: &subscription)
    }
}

