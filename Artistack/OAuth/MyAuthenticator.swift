//
//  MyAuthenticator.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/20.
//

import Foundation
import Alamofire

class MyAuthenticator: Authenticator {
    typealias Credential = MyAuthenticationCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        // bearerToken의 urlRequest대해서만 refresh를 시도 (true)
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        print("refresh호출됨")
        let hi = ReissueInput(accessToken: UserDefaults.standard.string(forKey: "accessToken")!, refreshToken:  UserDefaults.standard.string(forKey: "refreshToken")!)
        
        let header : HTTPHeaders = [
           "Content-Type" : "application/json;charset=UTF-8"]
        
        AF.request("https://dev.artistack.shop/oauth/reissue", method: .post, parameters: hi, encoder: JSONParameterEncoder.default, headers: header).validate().responseDecodable(of: ReissueModel.self){ response in
            switch response.result {
                case .success(let result):
                    print("재발급 성공")
                UserDefaults.standard.setValue(result.data.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(result.data.refreshToken, forKey: "refreshToken")
                    debugPrint(response)
                case .failure(let error):
                    print("재발급 실패")
                    print(error)
                
                // refresh Token 만료. 앱 종료
                print("refreshToken 만료. 앱을 강제 종료 합니다.")
//                exit(0)
                debugPrint(response)
                }
        
    }
}
}
