//
//  WantUInfo+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/11.
//

import Foundation

struct TotalWantPostDetail : Codable {
    var wantPostDetail : WantPostDetail
    var member : WantPostMember?
}

struct WantPostDetail : Codable {
    var postId : Int
    var title : String
    var description : String
    var createdAt : String
    var like : Bool
    var likeCount : Int
    var postImages : [WantPostImages]
}

struct WantPostMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}

struct WantPostImages : Codable, Hashable {
    var imageId : Int
    var image : String // image url
}

