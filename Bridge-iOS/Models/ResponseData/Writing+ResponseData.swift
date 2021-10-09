//
//  Writing+ResponseData.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/09/29.
//

import Foundation

struct WritingInfo : Codable {
    var info : BoardPostInfo
    var files : Data?
}
