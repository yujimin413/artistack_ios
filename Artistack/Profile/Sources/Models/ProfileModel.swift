//
//  ProfileModel.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/18.
//

struct ProfileModel : Decodable {
    var success : Bool
    var code : Int
    var message : String
    var data : profileData

}

struct profileData : Decodable {
    var artistackId : String
    var nickname : String
    var description : String
    var profileImgUrl : String
//    var instruments : [String:Any]
    var providerType : String
    var role : String
}
