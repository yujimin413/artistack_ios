//
//  Projects.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/15.
//

import Foundation

struct Project : Codable {
    var success: Bool
    var code: Int
    var message: String
    var data: CallInfo?
    
}

struct CallInfo: Codable {
    var content: [EachProject?]
    var pageable: Pageable
    var totalElements: Int
    var totalPages: Int
    var last: Bool
    var number: Int
    var sort: SortedCheck
    var size: Int
    var numberOfElements: Int
    var first: Bool
    var empty: Bool
    
    /*
    enum CodingKeys: String, CodingKey {
        case content
        case pageable
        case totalElements
        case totalPages
        case last
        case number
        case sort
        case size
        case numberOfElements
        case first
        case empty
    }*/
}

struct EachProject: Codable {
    var id: Int
    var videoUrl: String
    var title: String?
    var description: String?
    var bpm: String?
    var codeFlow: String?
    var scope: String
    var isStackable: Bool
    var viewCount: Int?
    var prevProjectId: Int?
    var user: User
    var instruments: [Instrument]
    var prevStackers: [StackerInfo?]
    var prevStackCount: Int
    var likeCount: Int
    var stackCount: Int
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case videoUrl
        case title
        case description
        case bpm
        case codeFlow
        case scope
        case isStackable
        case viewCount
        case prevProjectId
        case user
        case instruments
        case prevStackers
        case prevStackCount
        case likeCount
        case stackCount
        case isLiked
    }
}

struct StackerInfo: Codable {
    var nickname: String
    var profileImgUrl: String?
    var instruments: [Instrument]
}

struct Pageable: Codable {
    var sort: SortedCheck
    var offset: Int
    var pageNumber: Int
    var pageSize: Int
    var paged: Bool
    var unpaged: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case sort
        case offset
        case pageNumber
        case pageSize
        case unpaged
        case paged
    }
}

struct SortedCheck: Codable {
    var empty: Bool
    var sorted: Bool
    var unsorted: Bool
    
    enum CodingKeys: String, CodingKey {
        case empty
        case sorted
        case unsorted
    }
}
