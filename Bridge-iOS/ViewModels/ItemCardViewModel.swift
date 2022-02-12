//
//  ItemCardViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/29.
//

import Foundation
import Alamofire

final class ItemCardViewModel : ObservableObject {
    let post : Post
    @Published var isLiked : Bool
    
    init(post : Post) {
        self.post = post
        self.isLiked = post.liked
    }
    
    var imageUrl : String { post.image }
    var itemTitle : String { post.title }
    var itemPrice : String {
        //String(format: "%.1f", post.price)
        var src = String(Int(post.price))
        var len = src.count
        var count = 1
        
        while (len > (4 * count - 1)) { //
            src.insert(",", at: src.index(src.endIndex, offsetBy: (4 * count - 1) * -1))
            count += 1
            len += 1
        }
        
        return src
    }
    var camp : String { post.camp }
    //var isLiked : Bool { post.liked }
    var viewCount : Int { post.viewCount }
    
    func likePost() {
        let url = baseURL + "/used-posts/\(post.postId)/likes"
        let header: HTTPHeaders = [ "X-AUTH-TOKEN" : SignInViewModel.accessToken ]
        let method : HTTPMethod = isLiked ? .post : .delete
        
        print(isLiked ? "좋아요 할거임" : "좋아요 취소할거임")
        
        AF.request(url,
                   method: method,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { response in print(response) }
    }
}
