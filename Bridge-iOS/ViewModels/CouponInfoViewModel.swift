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
    @Published var reviews : [Review] = []
    
    @Published var showReviewAction : Bool = false
    @Published var selectedReview : Int = -1
    @Published var reviewIndexToDelete = 1000
    
    @Published var region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.520829, longitude: 127.022724),
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            )
    
    @Published var showAddReview : Bool = false
    @Published var reviewRate : Double = 5
    @Published var reviewText : String = ""
    
    @Published var isImageTap : Bool = false
    @Published var currentImageIndex : Int = 0
    
    private var subscription = Set<AnyCancellable>()
    
    @Published var coor : [Place] = [Place(name: "Apple Garosu-Gil", latitude: 37.520829, longitude: 127.022724)]
    var mapLink = URL(string: "maps://?saddr=&daddr=\(37.520829),\(127.022724)")
    
    let rateArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    let shopId : Int
    let shopImage : String
    
    init(_ shopId : Int, image : String) {
        self.shopId = shopId
        self.shopImage = image
        getStoreInfo()
        //getReview()
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
//                let coordinate = recievedValue.coordinate.components(separatedBy: [","," "])
//                let latitude = Double(coordinate[0]) ?? -1.0
//                let longtitude = Double(coordinate[2]) ?? -1.0
//                self?.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
//                self?.coor.append(Place(name: recievedValue.name, latitude: latitude, longitude: longtitude))
//                self?.mapLink = URL(string: "maps://?saddr=&daddr=\(latitude),\(longtitude)")
                //print(recievedValue)
                self?.shopInfo = recievedValue
                
            }.store(in: &subscription)
        }
    
    func getReview() {
        let url = "http://3.36.233.180:8080/shops/\(shopId)/reviews"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastReviewId" : 0],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                    case 200 :
                        print("Get Reviews Success : \(statusCode)")
                    default :
                        print("Get Reviews Fail : \(statusCode)")
                }
            }.publishDecodable(type : ReviewList.self)
            .compactMap { $0.value }
            .map { $0.reviewList }
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print(error.localizedDescription)
                case .finished :
                    print("Get Reviews Finished")
                }
            } receiveValue: { [weak self] (recievedValue : [Review]) in
                //print(recievedValue)
                self?.reviews = recievedValue
            }.store(in: &subscription)
    }
    
    func addReview() {
        let url = "http://3.36.233.180:8080/shops/\(shopId)/reviews"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .post,
                   parameters: [ "rate" : reviewRate,
                                 "content" : reviewText ],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { response in print(response) }
    }
    
    func modifyReview() {
        let url = "http://3.36.233.180:8080/shops/\(shopId)/reviews/\(selectedReview)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .post,
                   parameters: ["rate" : reviewRate,
                                "content" : reviewText ],
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { response in
                print(response)
            }
    }
    
    func deleteReview() {
        let url = "http://3.36.233.180:8080/shops/\(shopId)/reviews/\(selectedReview)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { response in
                print(response)
            }
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
