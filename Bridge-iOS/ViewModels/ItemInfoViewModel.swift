//
//  ItemInfoViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/05.
//

import Foundation
import Combine
import Alamofire

final class ItemInfoViewModel : ObservableObject {
    @Published var itemInfo : ItemInfo?
    
    //private let url = "http://3.36.233.180:8080/used-posts/291"
    private var subscription = Set<AnyCancellable>()
    private let token : String
    private let postId : Int
    
    init(token : String, postId : Int) {
        self.token = token
        self.postId = postId
        getItemInfo()
    }
    
    func getItemInfo() {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
        )
            .publishDecodable(type : ItemInfo.self)
            .compactMap { $0.value }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("finished")
                }
            } receiveValue: { [weak self] recievedValue in
                print(recievedValue)
                self?.itemInfo = recievedValue
                print(self?.itemInfo as Any)
            }.store(in: &subscription)
    }
}
