//
//  BlockUser+ResponseData.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/06.
//

import Foundation

struct BlockList : Codable {
    var blockList : [BlockInfo]
}

struct BlockInfo : Codable, Hashable {
    var blockId : Int
    var member : Member
    var blockedMember : Member
}

/*
 // In ItemInfo+ResponseData
 
 struct Member : Codable {
     var description : String
     var memberId : Int
     var profileImage : String
     var username : String
 }
*/
