//
//  SlideViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/07.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

final class SlideViewModel : ObservableObject {
    @Published var usedPostList : [Post] = []
    @Published var likedPostList : [Post] = []
    @Published var playPostLists : [PlayPostList] = []
    @Published var memberInfo : MemeberInformation
                                    = MemeberInformation(
                                        memberId: -1,
                                        username: "",
                                        description: "",
                                        profileImage: "",
                                        chatAlarm: false,
                                        playgroundAlarm: false,
                                        usedAlarm: false
                                    )
    @Published var isSignOutClicked : Bool = false
    @Published var signOutConfirm : Bool = false
    
    private var subscription = Set<AnyCancellable>()
    var userInfo : SignInResponse
    
    init(userInfo : SignInResponse) {
        self.userInfo = userInfo
    }
    
    func getUserInfo() {
        let url = "http://3.36.233.180:8080/members/\(userInfo.memberId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            //.responseJSON { response in print(response) }
            .publishDecodable(type : MemeberInformation.self)
            .compactMap { $0.value }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get UserInfo Finished")
                }
            } receiveValue: { [weak self] (recievedValue) in
                print(recievedValue)
                self?.memberInfo = recievedValue
            }.store(in: &subscription)
    }
    
    func getSellingList() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
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
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
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
    
    func getBoardPosts(token : String) {
        let url = "http://3.36.233.180:8080/members/\(userInfo.memberId)/playground?lastPostId=0"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
//                   parameters: ["lastPost": 1000],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseString{ (response) in
                //guard let statusCode = response.response?.statusCode else { return }
                //print(statusCode)
                print(response)
            }
            .publishDecodable(type : TotalPlayPostList.self)
            .compactMap { $0.value }
            .map { $0.playPostList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished boardView")
                }
            } receiveValue: { [weak self] (recievedValue : [PlayPostList]) in
                self?.playPostLists = recievedValue
                
            }.store(in: &subscription)
    }
    
    func signOut() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        let requestURL : String = "http://3.36.233.180:8080/sign-out"
        
        AF.request(requestURL,
                   method: .post,
                   parameters: ["deviceCode" : String(UIDevice.current.identifierForVendor!.uuidString)],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { json in print(json)}
    }
}
