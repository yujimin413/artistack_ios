//
//  SignInUserModel.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/14.
//

struct UserInput : Encodable {
    var artistackId : String?
    var nickname : String?
    var description : String?
    var providerType : String?
    var profileImgUrl : String?
//    var instruments : Array = [[String:Int]]()
}
