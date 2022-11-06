//
//  GetProjectModel.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/23.
//

import Foundation

struct Post2: Decodable {
    
    var success: Bool
    var code: Int
    var message: String
    var data: data3

}

struct data3: Decodable {
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
    var user: user2
    var instruments : [instruments2]
    var likeCount: Int
    var stackCount: Int
    var isLiked : Bool

}

struct user2: Decodable {
    var artistackId : String
    var nickname : String
    var profileImgUrl : String
}

struct instruments2: Decodable {
    var id : Int
    var name : String
    var imgUrl : String
}
