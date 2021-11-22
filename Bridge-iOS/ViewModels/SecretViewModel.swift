//
//  SecretViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

final class SecretViewModel : ObservableObject {
    let postList : SecretBoardPostInfo
//    let member : PostMember
    
    init(postList : SecretBoardPostInfo) {
        self.postList = postList
//        self.member = member
    }
    
    var imageUrl : String { postList.image }
    var postTitle : String { postList.title }
    var likeCount : Int { postList.likeCount }
    var commentCount : Int { postList.commentCount }
    var postId : Int { postList.postId }
    var description : String { postList.description }
    var createdAt : String { postList.createdAt }
    var profileImage : String { "https://static.thenounproject.com/png/741653-200.png"}
    var userName : String { "Anonymous" }
    
    
//    func stringToDate(createdAt : String) -> Date{
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//
//        return dateFormatter.date(from : createdAt)!
//    }
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
