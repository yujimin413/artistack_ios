//
//  MyprojectModel.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/18.
//

struct MyprojectDataModel : Decodable {
    var success : Bool?
    var code : Int?
    var message : String?
    var data : data2?
}

struct data2 : Decodable {
    
    var content : [content]?
    var pageable : pageable?
    var last : Bool? // 현재 페이지가 마지막인가
    var totalPages : Int? // 전체 페이지 수
    var totalElements : Int?// 전체 데이터 개수
    var first : Bool? // 현재 페이지가 첫번째인가
    var size : Int?
    var number : Int?
    var sort : sort
    var numberOfElements : Int?  // 현재 페이지 데이터 개수
    var empty: Bool?
}

struct content : Decodable{
    var id : Int?
    var videoUrl : String?
    var viewCount : Int?
    var likeCount :  Int?
    var stackCount : Int?
}

struct pageable : Decodable{
    var sort : sort?
    var offset : Int?
    var pageNumber : Int?
    var pageSize : Int?
    var paged : Bool?
    var unpaged : Bool?

}

struct sort : Decodable{
    var empty : Bool?
    var unsorted : Bool?
    var sorted : Bool?
}



