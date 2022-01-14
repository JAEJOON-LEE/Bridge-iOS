//
//  CouponInfoViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/15.
//

import Foundation
import Alamofire
import Combine
import MapKit

final class CouponInfoViewModel : ObservableObject {
    @Published var shopInfo : ShopInfo = ShopInfo(
                                            shopId: 0,
                                            name: "",
                                            location: "",
                                            coordinate: "",
                                            description: "",
                                            oneLineDescription: "",
                                            rate: 0.0,
                                            reviewCount: 0,
                                            benefit: "",
                                            images: []
                                        )
    
    @Published var region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.520829, longitude: 127.022724),
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            )
    
    let coor = [Place(name: "Apple Garosu-Gil", latitude: 37.520829, longitude: 127.022724)]

    private var subscription = Set<AnyCancellable>()
    let shopId : Int
    
    init(_ shopId : Int) {
        self.shopId = shopId
        getStoreInfo()
    }
    
    func getStoreInfo() {
        let url = "http://3.36.233.180:8080/shops/\(shopId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { [weak self] (response) in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                    case 200 :
                        print("Get Store Info Success : \(statusCode)")
                    default :
                        print("Get Store Info Fail : \(statusCode)")
                        self?.getStoreInfo()
                }
            }.publishDecodable(type : ShopInfo.self)
            .compactMap { $0.value }
            //.map { $0.shopList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Store Info Finished")
                }
            } receiveValue: { [weak self] (recievedValue : ShopInfo) in
                print(recievedValue)
                self?.shopInfo = recievedValue
            }.store(in: &subscription)
        }
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
