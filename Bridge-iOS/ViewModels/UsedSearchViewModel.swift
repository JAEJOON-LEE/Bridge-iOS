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
    @Published var hotDealPosts : [Post] = []
    @Published var searchedPosts : [Post] = []
    
    @Published var selectedCamp : String = "Casey/Hovey" //"Camp Casey"
    @Published var searchString : String = ""
    @Published var selectedCategory : String = "Etc"
    @Published var categoryViewShow = false
    @Published var searchResultViewShow = false
    
    @Published var isSearchResultEmpty : Bool = false
    @Published var isCategoryResultEmpty : Bool = false
    
    private let url = baseURL + "/used-posts?"
    private var subscription = Set<AnyCancellable>()

    let memberId : Int
    let userInfo : MemeberInformation
    
    var categories : [String] = ["Digital", "Interior", "Fashion", "Life", "Beauty", "Etc"]
    //["Digital", "Furniture", "Food", "Clothes", "Beauty", "Etc."]
    var currentCamp : String = ""
    
    init(memberId : Int, currentCamp : String, userInfo : MemeberInformation) {
        self.memberId = memberId
        self.currentCamp = currentCamp
        self.userInfo = userInfo
        getHotDealPosts()
    }
    
    func getPostsByCategory(category : String) {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        Posts.removeAll()
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp" : 0,
                                "lastArea" : 0,
                                "category" : category,
                                "camp" : CampEncoding[currentCamp]! ],
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
                    print("Get Posts by category Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
//                print(recievedValue)
                if recievedValue.isEmpty { self?.isCategoryResultEmpty = true }
                self?.Posts = recievedValue
            }.store(in: &subscription)
    }
    
    func getHotDealPosts() {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        Posts.removeAll()
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp" : 0,
                                "lastArea" : 0,
                                "hot" : true,
                                "camp" : CampEncoding[currentCamp]! ],
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
                    print("Get hot deal Posts Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
//                print(recievedValue)
                self?.hotDealPosts = recievedValue
            }.store(in: &subscription)
    }
    
    func getPostsByQuery(query : String) {
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        isSearchResultEmpty = false
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastCamp" : 0,
                                "lastArea" : 0,
                                "query" : query,
                                "camp" : CampEncoding[currentCamp]! ],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { response in print(response) }
            .publishDecodable(type : Element.self)
            .compactMap { $0.value }
            .map { $0.postList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Posts by query Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Post]) in
                //print(recievedValue)
                if recievedValue.isEmpty { self?.isSearchResultEmpty = true }
                self?.searchedPosts = recievedValue
            }.store(in: &subscription)
    }
}
