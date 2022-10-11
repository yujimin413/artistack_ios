//
//  ImageModel.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/15.
//

struct ImageModel : Decodable {
    var success : Bool
    var code : Int
    var message : String
    var data : String
}
