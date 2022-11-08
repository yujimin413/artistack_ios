    //
    //  ProfileDataManager.swift
    //  Artistack
    //
//  Created by 유지민 on 2022/08/10.
//

import Alamofire
import Foundation

class ProfileEditDataManager {
    func profileEditDataManager(_ parameter: ProfileEditInput, _ completion: @escaping () -> Void) {

        guard let acToken = UserDefaults.standard.string(forKey: "accessToken")
            else
            {
                print("ProfileEditDataManager에서 어세스 토큰 nil 확인")
                return
            }
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: acToken,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        
        let header : HTTPHeaders = [
           "Content-Type" : "application/json;charset=UTF-8",
           "Authorization": "Bearer " + signInAccessToken!]
        
        // 프로필화면 수정
        AF.request("https://dev.artistack.shop/users/me",
                   method: .patch,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: header,
        interceptor: myAuthencitationInterceptor).validate().responseDecodable(of: ProfileEditModel.self) { response in
            switch response.result {
                case .success(let result):
                    print("프로필 화면 수정 성공")
                    debugPrint(response)
                    completion()
                case .failure(let error):
                    print("프로필 화면 수정 실패")
//                    print(error.localizedDescription)
                    debugPrint(response)
            }
        }
    }
}
