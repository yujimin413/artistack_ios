//
//  ProfileDataManager.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/10.
//

import Alamofire
import Foundation

class UserDataManager {
    
    var delegate : KeychainAccessImpl?
    
    func userDataManager(_ parameter: UserInput) {
        let kakaoAccessToken = UserDefaults.standard.string(forKey: "kakaoAccessToken")
        
        let header : HTTPHeaders = [
           "Content-Type" : "application/json;charset=UTF-8",
           "Authorization": "Bearer \(kakaoAccessToken!)"]
        
//        let params = UserModel(artistackId: "b", nickname: "b", description: "b", providerType: "b", profileImgUrl: "b")
        
        AF.request("https://dev.artistack.shop/oauth/sign-up", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: header).validate().responseDecodable(of: UserModel.self) { response in
            switch response.result {
                case .success(let result):
                    print("회원가입 성공")
                    debugPrint(response)
                    print("회원가입 어세스 토큰")
                    print(response.value!.data.accessToken)
                
                UserDefaults.standard.setValue(result.data.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(result.data.refreshToken, forKey: "refreshToken")
                
                                        
                let signinAccessToken = response.value!.data.accessToken
//                SignInAccessToken.sharedInstance().signInAccessToken = signinAccessToken
                UserDefaults.standard.set(signinAccessToken, forKey: "accessToken")
                
                
                case .failure(let error):
                print("회원가입 실패")
                    print(error)
                debugPrint(response)
                
                // 회원가입 실패시 앱 강제 종료
                print("회원가입 실패. 강제 종료")
                exit(0)
                }

        }
    }
    
}
