//
//  SecretInfo+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/11.
//

import Foundation

struct TotalSecretPostDetail : Codable {
    var secretPostDetail : SecretPostDetail
    var member : SecretPostMember?
}

struct SecretPostDetail : Codable {
    var postId : Int
    var title : String
    var description : String
    var createdAt : String
    var like : Bool
    var likeCount : Int
    var postImages : [SecretPostImages]
}

struct SecretPostMember : Codable, Hashable {
    var memberId : Int?
    var username : String?
    var description : String?
    var profileImage : String?
}

struct SecretPostImages : Codable, Hashable {
    var imageId : Int
    var image : String // image url
}

