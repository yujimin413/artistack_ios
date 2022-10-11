//
//  Like.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/18.
//

import Foundation

struct Like: Codable {
    
    var success: Bool
    var code: Int
    var message: String
    var data: String?

}
