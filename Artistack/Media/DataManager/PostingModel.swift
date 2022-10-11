//
//  PostingModel.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/10.
//

import Foundation
 
struct postingModel : Decodable{
    
    var success : Bool
    var code : Int
    var message : String
    var data : String
}
