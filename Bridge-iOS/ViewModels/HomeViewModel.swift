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
    
    private let url = "http://3.36.233.180:8080/used-posts?"
    private var subscription = Set<AnyCancellable>()
    let token : String
    
    init(accessToken : String) {
        self.token = accessToken
        getPosts(token : accessToken)
    }
    
    func getPosts(token : String) {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp":0,
                                "lastArea":0,
                                "camp":"Camp Casey"],
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
                    print("finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
//                print(recievedValue)
                self?.Posts = recievedValue
//                print(self?.Posts[0])
            }.store(in: &subscription)
    }
}
