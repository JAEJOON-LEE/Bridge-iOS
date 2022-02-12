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

struct Place : Identifiable {
    let id = UUID()
    let name : String
    let latitude : Double
    let longitude : Double
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

final class CouponInfoViewModel : ObservableObject {
    @Published var shopInfo : ShopInfo = ShopInfo(
                                            shopId: 0,
                                            name: "",
                                            location: "",
                                            coordinate: "",
                                            description: "",
                                            oneLineDescription: "",
                                            //rate: 0.0,
                                            reviewCount: 0,
                                            benefit: "",
                                            images: []
                                        )
    @Published var reviews : [Review] = []
    @Published var lastReviewId : Int = 0
    
    @Published var showReviewAction : Bool = false
    @Published var selectedReview : Int = -1
    @Published var isModifying : Bool = false
    @Published var modifyText : String = ""
    @Published var reviewIndexToDelete = 1000
    
    @Published var addReviewDone : Bool = false
    @Published var reviewText : String = ""
    
    @Published var isImageTap : Bool = false
    @Published var currentImageIndex : Int = 0
    @Published var ImageViewOffset = CGSize.zero

    @Published var invalidLocation : Bool = false
    @Published var coor : [Place] = []
    // Place(name: "Apple Garosu-Gil", latitude: 37.520829, longitude: 127.022724)]
    
    // Default location
    @Published var region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.520829, longitude: 127.022724),
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            )
    var mapLink = URL(string: "maps://?saddr=&daddr=\(37.520829),\(127.022724)")
    
    private var subscription = Set<AnyCancellable>()
    
    let shopId : Int
    let shopImage : String
    
    init(_ shopId : Int, image : String) {
        self.shopId = shopId
        self.shopImage = image
        getStoreInfo()
        //getReview()
    }
    
    func getStoreInfo() {
        let url = baseURL + "/shops/\(shopId)"
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
                //print(recievedValue)
                
                // Parsing latitude and longtitude
                let coordinate = recievedValue.coordinate.components(separatedBy: [","," "])
                let latitude = Double(coordinate[0]) ?? -100.0
                let longitude = Double(coordinate[2]) ?? -200.0 // 띄어쓰기

                // Invalid latitude or longtitude exception handling
                if abs(latitude) > 90 || abs(longitude) > 180 {
                    self?.invalidLocation = true
                } else {
                    self?.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self?.coor.append(Place(name: recievedValue.name, latitude: latitude, longitude: longitude))
                }
                
                self?.mapLink = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                
                self?.shopInfo = recievedValue
            }.store(in: &subscription)
        }
    
    func getReview() {
        let url = baseURL + "/shops/\(shopId)/reviews"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .get,
                   parameters: ["lastReviewId" : lastReviewId],
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
                if self?.lastReviewId == 0 { self?.reviews = recievedValue }
                else { self?.reviews.append(contentsOf: recievedValue) }
            }.store(in: &subscription)
    }
    
    func addReview() {
        let url = baseURL + "/shops/\(shopId)/reviews"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .post,
                   parameters: [ "content" : reviewText ],
                   encoder: JSONParameterEncoder.prettyPrinted,
                   headers: header)
            .responseJSON { [weak self] response in
                print(response)
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 500 :
                    print("Add Review Fail : \(statusCode)")
                default :
                    print("Add Review Done : \(statusCode)")
                    self?.addReviewDone = true
                    self?.getReview()
                }
            }
    }
    
    func modifyReview() {
        let url = baseURL + "/shops/\(shopId)/reviews/\(selectedReview)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .post,
                   parameters: [ "content" : modifyText ],
                   encoder: JSONParameterEncoder.prettyPrinted,
                   headers: header)
            .responseJSON { [weak self] response in
                print(response)
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 500 :
                    print("Modify Review Fail : \(statusCode)")
                default :
                    print("Modify Review Done : \(statusCode)")
                    self?.getReview()
                }
            }
    }
    
    func deleteReview() {
        let url = baseURL + "/shops/\(shopId)/reviews/\(selectedReview)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header)
            .responseJSON { [weak self] response in
                print(response)
                self?.getReview()
            }
    }
}
