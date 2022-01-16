//
//  CouponViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/14.
//

import Foundation
import Alamofire
import Combine

final class CouponViewModel : ObservableObject {
    @Published var selectedCamp : String = "Casey/Hovey" //"Camp Casey"
    @Published var selectedCategory : Int = 1 // 1 : Restaurant , 2 : Local Store , 3 : B-Selection
    @Published var shops : [Shop] = []
    @Published var shopsRandom : [Shop] = []

    private var subscription = Set<AnyCancellable>()
    
    let memberInfo : Member
    
    init(member : Member) {
        memberInfo = member
    }
    
    let locations = ["Casey/Hovey", "USAG Yongsan", "K-16", "Suwon A/B", "Osan A/B", "Camp Humperys", "Camp Carroll", "Henry/Walker", "Gunsan A/B"]

    func getStore() {
        let url = "http://3.36.233.180:8080/shops?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        var shopType : String {
            if selectedCategory == 1 {
                return "RESTAURANT"
            } else if selectedCategory == 2 {
                return "LOCAL_STORE"
            } else { // selectedCategory == 3
                return "B_SELECTION"
            }
        }
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastShopId" : 0,
                                "shopType" : shopType,
                                "camp" : selectedCamp],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                    case 200 :
                        print("Get Stores Success : \(statusCode)")
                    default :
                        print("Get Stores Fail : \(statusCode)")
                        self?.getStore()
                }
            }.publishDecodable(type : ShopList.self)
            .compactMap { $0.value }
            .map { $0.shopList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Stores Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Shop]) in
                //print(recievedValue)
                self?.shops = recievedValue
            }.store(in: &subscription)
        }
    
    func getRandomStore() {
        let url = "http://3.36.233.180:8080/shops?"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN": SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastShopId" : 0,
                                "camp" : selectedCamp,
                                "random" : true],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                    case 200 :
                        print("Get Random Stores Success : \(statusCode)")
                    default :
                        print("Get Random Stores Fail : \(statusCode)")
                        self?.getStore()
                }
            }.publishDecodable(type : ShopList.self)
            .compactMap { $0.value }
            .map { $0.shopList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Random Stores Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Shop]) in
                //print(recievedValue)
                self?.shopsRandom = recievedValue
            }.store(in: &subscription)
        }
}
