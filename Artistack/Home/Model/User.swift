//
//  User.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/09.
//

import Foundation

struct User: Codable {
    var artistackId: String
    var nickname: String
    var profileImgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case artistackId
        case nickname
        case profileImgUrl
    }
}
