//
//  Stack.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/10.
//

import Foundation

struct Stack: Codable {
    
    var success: Bool
    var code: Int
    var message: String
    var data: CallStackInfo?

}

struct CallStackInfo: Codable {
    var content: [EachStack?]
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

}

struct EachStack: Codable {
    
    var nickname: String
    var profileImgUrl: String?
    var instruments: [Instrument]
    var project: stProject
    
}

struct stProject: Codable {
    
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
    var likeCount: Int
    var stackCount: Int
    
    
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
        case likeCount
        case stackCount
    }
    
}
