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
    @Published var isMemberInfoClicked : Bool = false
    @Published var isLiked : Bool?
    @Published var isImageTap : Bool = false
    @Published var showAction : Bool = false
    @Published var showConfirmDeletion : Bool = false
    @Published var showPostModify : Bool = false
    @Published var currentImageIndex : Int = 0
    
    private var subscription = Set<AnyCancellable>()
    
    var previousLikeStatus : Bool = false
    
    let token : String
    let postId : Int
    let isMyPost : Bool
    
    init(token : String, postId : Int, isMyPost : Bool) {
        self.token = token
        self.postId = postId
        self.isMyPost = isMyPost
        getItemInfo()
    }
    
    var formattedPrice : String {
        guard let numToCal = itemInfo?.usedPostDetail.price else { return "" }
        var src = String(Int(numToCal))
        let len = src.count
        var count = 1

        while (len > (4 * count - 1)) { //
            src.insert(",", at: src.index(src.endIndex, offsetBy: (4 * count - 1) * -1))
            count += 1
        }
        
        return src
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
                    print("Get Item Info Finished")
                }
            } receiveValue: { [weak self] recievedValue in
                //print(recievedValue)
                self?.itemInfo = recievedValue
                self?.isLiked = recievedValue.usedPostDetail.like
                self?.previousLikeStatus = recievedValue.usedPostDetail.like
                //print(self?.itemInfo as Any)
            }.store(in: &subscription)
    }
    
    func likePost(isliked : Bool) {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        let method : HTTPMethod = isliked ? .delete : .post
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).response { json in
//            print(json)
        }
    }
    
    func deletePost() {
        let url = "http://3.36.233.180:8080/used-posts/\(postId)"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : token ]
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { json in
//            print(json)
        }
    }
}
