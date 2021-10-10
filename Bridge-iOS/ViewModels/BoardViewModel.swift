//
//  BoardViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation
import Combine
import Alamofire

final class BoardViewModel : ObservableObject {
    @Published var postLists : [PostList] = []
    @Published var hotLists : [PostList] = []
    @Published var wantLists : [WantUPostList] = []
//    @Published var postMembers : [PostMember] = []
    
    private var subscription = Set<AnyCancellable>()
    let token : String
    
    init(accessToken : String) {
        self.token = accessToken
        getBoardPosts(token : accessToken)
        getWantPosts(token : accessToken)
        getHotPosts(token : accessToken)
    }
    
    func getBoardPosts(token : String) {
        let url = "http://3.36.233.180:8080/board-posts?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastPost": 1000],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseString{ (response) in
                
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    print(statusCode)
                print(response)
            }
            .publishDecodable(type : TotalPostList.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished boardView")
                }
            } receiveValue: { [weak self] (recievedValue : [PostList]) in
                self?.postLists = recievedValue
                print(recievedValue)
                
            }.store(in: &subscription)
    }
    
    func getHotPosts(token : String) {
        let url = "http://3.36.233.180:8080/board-posts?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastPost": 1000,
                                "hot": true ],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseString{ (response) in
                
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    print(statusCode)
                print(response)
            }
            .publishDecodable(type : TotalPostList.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished boardView")
                }
            } receiveValue: { [weak self] (recievedValue : [PostList]) in
                self?.hotLists = recievedValue
                print(recievedValue)
                
            }.store(in: &subscription)
    }
    
    func getWantPosts(token : String) {
        let url = "http://3.36.233.180:8080/want-posts?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]

        AF.request(url,
                   method: .get,
//                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseString{ (response) in

                    guard let statusCode = response.response?.statusCode else { return }

                    print(statusCode)
                print(response)
            }
            .publishDecodable(type : WantUTotalPostList.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished wantPost")
                }
            } receiveValue: { [weak self] (recievedValue : [WantUPostList]) in
                self?.wantLists = recievedValue
//                print(recievedValue)

            }.store(in: &subscription)
    }
}
