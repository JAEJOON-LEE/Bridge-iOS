//
//  HomeViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/28.
//

import Foundation
import Combine
import Alamofire

final class HomeViewModel : ObservableObject {
    @Published var Posts : [Post] = []
    @Published var selectedCamp : String = "Casey/Hovey" //"Camp Casey"
    @Published var isSearchViewShow : Bool = false
    @Published var postFetchDone : Bool = false
    @Published var memberInfo : MemeberInformation?
    
    private var subscription = Set<AnyCancellable>()
    let token : String
    let memberId : Int
    //let locations = ["Camp Casey", "Camp Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Camp Henry", "Camp Walker", "Gunsan A/B"]
    let locations = ["Casey/Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Henry/Walker", "Gunsan A/B"]

    init(accessToken : String, memberId : Int) {
        self.token = accessToken
        self.memberId = memberId
        getPosts()
        getUserInfo()
    }
    
    func getPosts() {
        let url = "http://3.36.233.180:8080/used-posts?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp" : 0,
                                "lastArea" : 0,
                                "camp" : selectedCamp],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                    case 200 :
                        print("Post Fetching Success : \(statusCode)")
                        self?.postFetchDone = true
                    default :
                        print("Post Fetching Fail : \(statusCode)")
                }
            }.publishDecodable(type : Element.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Posts Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
//                print(recievedValue)
                self?.Posts = recievedValue
            }.store(in: &subscription)
    }
    
    func getUserInfo() {
        let url = "http://3.36.233.180:8080/members/\(memberId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
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
}
