//
//  SlideViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/07.
//

import Foundation
import Alamofire
import Combine

final class SlideViewModel : ObservableObject {
    @Published var usedPostList : [Post] = []
    //@Published var playPostList
    @Published var likedPostList : [Post] = []
    
    private var subscription = Set<AnyCancellable>()
    var userInfo : SignInResponse
    
    init(userInfo : SignInResponse) {
        self.userInfo = userInfo
    }
    
    func getSellingList() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": userInfo.token.accessToken ]
        let requestURL : String
        = "http://3.36.233.180:8080/members/\(userInfo.memberId)/used-posts?lastPostId=0"

        AF.request(requestURL,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            .publishDecodable(type : Element_Selling.self)
            .compactMap { $0.value }
            .map { $0.usedPostList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Selling List Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
                //print(recievedValue)
                self?.usedPostList = recievedValue
            }.store(in: &subscription)
    }
    func getLikedList() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": userInfo.token.accessToken ]
        let requestURL : String
        = "http://3.36.233.180:8080/members/\(userInfo.memberId)/liked-used-posts?lastPostId=0"

        AF.request(requestURL,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            .publishDecodable(type : Element.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Selling List Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
                print(recievedValue)
                self?.likedPostList = recievedValue
            }.store(in: &subscription)
    }
}
