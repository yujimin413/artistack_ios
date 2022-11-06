//
//  GetProjectDataManager.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/23.
//

import Foundation
import Alamofire


func GetProject(projectId: Int, completion: @escaping(_ data : data3) -> Void) {
    
    
    let authenticator = MyAuthenticator()
    let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                expiredAt: Date(timeIntervalSinceNow: 60 * 3))

    let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                credential: credential)
    let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
    
    
    let header : HTTPHeaders = [
       "Content-Type" : "application/json;charset=UTF-8",
       "Authorization": "Bearer " + signInAccessToken!]
    

    let url =  "https://dev.artistack.shop/projects/" + String(projectId)

    
        print("Getproject 함수 실행")
    AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Post2.self){ response in
            switch response.result {
            case .success(let result) :
                print("게시물 조회 성공")
                debugPrint(response)
                
                completion(result.data)
            case .failure(let error) :
                print("게시물 조회 실패")
                debugPrint(response)
                return
            }
        }
}
