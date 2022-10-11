//
//  LikedList.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/22.
//

import Foundation

struct LikedList: Codable {
    
    var success: Bool
    var code: Int
    var message: String
    var data: EachProjectLiked?

}

struct EachProjectLiked: Codable {
    var content: [Person?]
    var pageable: Pageable
    var totalPages: Int
    var totalElements: Int
    var last: Bool
    var number: Int
    var sort: SortedCheck
    var size: Int
    var numberOfElements: Int
    var first: Bool
    var empty: Bool
}

struct Person: Codable {
    var artistackId: String
    var nickname: String
    var profileImgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case artistackId
        case nickname
        case profileImgUrl
    }
}
