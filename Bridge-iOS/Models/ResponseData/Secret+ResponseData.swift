//
//  Secret+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

//struct SecretTotalPostList : Codable, Hashable {
//    var postD : SecretBoardPostInfo
//}

struct SecretPostList : Codable, Hashable {
    var postList : [SecretBoardPostInfo]
//    var member : SecretBoardMember?
}

struct SecretBoardPostInfo : Codable, Hashable{
    var postId : Int
    var postType : String
    var title : String
    var image : String
    var description : String
    var likeCount : Int
    var like : Bool
    var commentCount : Int
    var createdAt : String
}

//struct SecretBoardMember : Codable, Hashable {
//    var memberId : Int?
//    var username : String?
//    var description : String?
//    var profileImage : String?
//}

