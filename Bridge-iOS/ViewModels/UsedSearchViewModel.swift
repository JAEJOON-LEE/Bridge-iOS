//
//  UsedSearchViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/15.
//

import Foundation
import Alamofire
import Combine

final class UsedSearchViewModel : ObservableObject {
    @Published var Posts : [Post] = []
    @Published var selectedCamp : String = "Camp Casey"
    @Published var searchString : String = ""
    @Published var selectedCategory : String = "etc."
    @Published var categoryViewShow = false
    
    private let url = "http://3.36.233.180:8080/used-posts?"
    private var subscription = Set<AnyCancellable>()

    let token : String
    let memberId : Int
    
    var categories : [String] = ["Digital", "Furniture", "Food", "Clothes", "Beauty", "Etc."]
    var currentCamp : String = ""
    
    init(accessToken : String, memberId : Int, currentCamp : String) {
        self.token = accessToken
        self.memberId = memberId
        self.currentCamp = currentCamp
    }
    
    func getPostsByCategory(category : String) {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": token ]
        Posts.removeAll()
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp" : 0,
                                "lastArea" : 0,
                                "category" : category,
                                "camp" : currentCamp],
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
                    print("Get Posts Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
//                print(recievedValue)
                self?.Posts = recievedValue
            }.store(in: &subscription)
    }
}
