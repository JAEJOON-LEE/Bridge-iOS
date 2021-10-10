//
//  WantU+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

struct WantUTotalPostList : Codable, Hashable {
    var postList : [WantUPostList]
}

struct WantUPostList : Codable, Hashable {
    var postInfo : WantUBoardPostInfo
    var member : WantUBoardMember?
}

struct WantUBoardPostInfo : Codable, Hashable{
    var postId : Int
    var title : String
    var likeCount : Int
    var image : String
    var commentCount : Int
    var description : String
    var createdAt : String
}

struct WantUBoardMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}

