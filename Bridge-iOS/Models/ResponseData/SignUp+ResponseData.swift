//
//  SignUp+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/06.
//

import Foundation

struct SignUpInfo : Codable {
    var info : MemberInfo
    var profileImage : Data?
}

struct MemberInfo : Codable {
    var name : String
    var email : String
    var password : String
    var role : String?
    var description : String?
    var username : String?
}
