//
//  KakaoModel.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/18.
//

struct KakaoModel : Decodable {
    var success : Bool?
    var code : Int?
    var message : String?
    var data : kakaoData?
}

struct kakaoData : Decodable {
    var grantType : String?
    var accessToken : String?
    var refreshToken : String?
    var accessTokenExpiresIn : Int?
    
    var nickname : String?
    var profileImgUrl : String?
}
