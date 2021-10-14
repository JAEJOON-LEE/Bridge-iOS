//
//  ItemCardViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/09/29.
//

import Foundation

final class ItemCardViewModel : ObservableObject {
    let post : Post
    init(post : Post) {
        self.post = post
    }
    var imageUrl : String { post.image }
    var itemTitle : String { post.title }
    var itemPrice : String {
        //String(format: "%.1f", post.price)
        var src = String(Int(post.price))
        let len = src.count
        var count = 1
        
        while (len > (4 * count - 1)) { //
            src.insert(",", at: src.index(src.endIndex, offsetBy: (4 * count - 1) * -1))
            count += 1
        }
        
        return src
    
    }
    var camp : String { post.camp }
    var isLiked : Bool { post.liked }
    var viewCount : Int { post.viewCount }
}
