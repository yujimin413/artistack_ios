//
//  ReissueModel.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/19.
//


struct ReissueModel : Decodable {
    var success : Bool
    var code : Int
    var message : String
    var data : ReissueData
    
}

struct ReissueData : Decodable{
    var grantType: String
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresIn : Int
}
