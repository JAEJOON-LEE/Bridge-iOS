//
//  Secret+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

struct SecretTotalPostList : Codable, Hashable {
    var postList : [SecretPostList]
}

struct SecretPostList : Codable, Hashable {
    var postInfo : SecretBoardPostInfo
    var member : SecretBoardMember?
}

struct SecretBoardPostInfo : Codable, Hashable{
    var postId : Int
    var title : String
    var likeCount : Int
    var image : String
    var commentCount : Int
    var description : String
    var createdAt : String
}

struct SecretBoardMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}

