//
//  aaaaaaa.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/15.
//

struct UserModel : Decodable {
    var success : Bool
    var code : Int
    var message : String
    var data : data
    
    
    
//    {
//      "grantType":"bearer",
//      "accessToken":"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiYXJ0aXN0YWNrSWQiOiJ0ZXN0SWRJRCIsIm5pY2tuYW1lIjoibm5ubm9ja25tYWUiLCJwcm92aWRlclR5cGUiOiJLQUtBTyIsInJvbGUiOiJVU0VSIiwiYXV0aCI6IlVTRVIiLCJleHAiOjE2NTg2NjUyODJ9.dy-AEWXN7rV00VlBoD80Zq8tNPDWLnFnygABnaclIDkPrTorkb0P-0S2Gcjv46i4aHfRYSz4r9gOu_UzSRT3dQ",
//      "refreshToken":"eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2NjEyNTU0ODJ9.mYACc814J-x5ZD57yjEGFh70tMToya1K-trorBHEu1jSjOjMFV7anE8YOhwoWve4S8_DLkfd2O2XKNrmhtnrDQ",
//      "accessTokenExpiresIn":1658665282735
//    }
}

struct data : Decodable {
    var grantType: String
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresIn: Int
}
