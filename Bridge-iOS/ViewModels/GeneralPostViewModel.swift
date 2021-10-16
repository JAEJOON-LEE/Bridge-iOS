//
//  GeneralPostViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation

final class GeneralPostViewModel : ObservableObject {
    let postList : PostList
    
    init(postList : PostList) {
        self.postList = postList
    }
    
    var imageUrl : String? { postList.postInfo.image }
    var postTitle : String { postList.postInfo.title }
    var likeCount : Int { postList.postInfo.likeCount }
    var commentCount : Int { postList.postInfo.commentCount }
    var anonymous : Bool { postList.postInfo.anonymous }
    var postId : Int { postList.postInfo.postId }
    var description : String { postList.postInfo.description }
    var createdAt : String { postList.postInfo.createdAt }
    var profileImage : String { postList.member?.profileImage ?? "https://static.thenounproject.com/png/741653-200.png"}
    var userName : String { postList.member?.username ?? "Anonymous" }
    
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
