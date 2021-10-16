//
//  PostInfo+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation

struct TotalBoardPostDetail : Codable {
    var boardPostDetail : BoardPostDetail
    var member : PostMember?
}

struct BoardPostDetail : Codable {
    var postId : Int
    var title : String
    var description : String
    var createdAt : String 
    var anonymous : Bool
    var like : Bool
    var likeCount : Int
    var postImages : [PostImages]?
}

struct PostMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImg : String?
}

struct PostImages : Codable, Hashable {
    var imageId : Int
    var image : String // image url
}
