//
//  ProfileModel.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/17.
//


struct ProfileEditModel : Decodable {
    var success : Bool
    var code : Int
    var message : String
    var data : profileEditData

}

struct profileEditData : Decodable {
    var artistackId : String
    var nickname : String
    var description : String
    var profileImgUrl : String
    var providerType: String
    var role : String
}
