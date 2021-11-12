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
    
    func convertReturnedDateString(_ timeString : String) -> String {
        var str = timeString
        str.removeSubrange(str.index(str.endIndex, offsetBy: -7)..<str.endIndex)
        str.remove(at: str.index(str.startIndex, offsetBy: 10))
        str.insert(" ", at: str.index(str.startIndex, offsetBy: 10))
        
        let korNow = Date(timeIntervalSinceNow: 32400) // UTC + 9H
        let timetravel = korNow.timeIntervalSince(str.toDate() ?? Date())
        
        if Int(timetravel) < 60 {
            return "\(Int(timetravel)) Seconds ago"
        } else if (60 <= Int(timetravel)) && (Int(timetravel) < 3600) {
            return "\(Int(timetravel) / 60) Minutes ago"
        } else if (3600 <= Int(timetravel)) && (Int(timetravel) < 86400) {
            return "\(Int(timetravel) / 3600) Hours ago"
        } else if (86400 <= Int(timetravel)) && (Int(timetravel) < (86400 * 7)) { // 7일까지
            return "\(Int(timetravel) / 86400) Days ago"
        } else {
            str.removeSubrange(str.index(str.endIndex, offsetBy: -9)..<str.endIndex)
            return str
        }
    }
}
