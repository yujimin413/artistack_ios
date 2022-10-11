//
//  PostingInput.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/10.
//



import Foundation

struct dto : Encodable {
    var title : String
    var description : String?
    var bpm: String?
    var codeFlow: String?
    var instrumentIds : [Int]
    var scope: String
    var isStackable : Bool
}
