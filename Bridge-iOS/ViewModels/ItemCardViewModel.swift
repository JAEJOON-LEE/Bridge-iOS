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
        var formattedPrice = String(Int(post.price))
        let len = formattedPrice.count
        var count = 1
        
        while (len > (2 * count + 1)) { //
            formattedPrice.insert(",", at: formattedPrice.index(formattedPrice.endIndex, offsetBy: (2 * count + 1) * -1))
            count += 1
        }
        
        return formattedPrice
    }
    var camp : String { post.camp }
    var isLiked : Bool { post.liked }
    var viewCount : Int { post.viewCount }
}
