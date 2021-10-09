//
//  Writing+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/29.
//

import Foundation

struct WritingInfo : Codable {
    var info : PostInfo
    var files : Data?
}

struct PostInfo : Codable {
    var title : String
    var description : String
    var anonymous : Bool
}
