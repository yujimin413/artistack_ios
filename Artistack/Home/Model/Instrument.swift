//
//  Instrument.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/09.
//

import Foundation

struct Instrument: Codable {
    var id: Int
    var name: String
    var imgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imgUrl
    }
}

