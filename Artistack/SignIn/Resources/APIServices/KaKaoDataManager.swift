//
//  KaKaoDataManager.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/18.
//

import Alamofire
import Foundation

class KakaoDataManager {
    func kakaoDataManager(_ kakaoCompletion: @escaping (Bool) -> Void) {
        // 카카오 로그인
        print("카카오 로그인 여부 확인")
        let url = "https://dev.artistack.shop/oauth/sign-in?providerType=KAKAO"
//        let kakaoAccessToken = KakaoAccessToken.sharedInstance().kakaoAccessToken
        

        guard let kakaoAccessToken = UserDefaults.standard.string(forKey: "kakaoAccessToken")
        else{
            print("카카오어세스 토큰nil")
            return
        }
        let header : HTTPHeaders = ["Content-Type":"application/json;charset=UTF-8", "Authorization": "Bearer " + kakaoAccessToken]
        var isKakaoLoggedIn : Bool!

        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate().responseDecodable(of: KakaoModel.self) { response in
            switch response.result {
            case .success(let result):
                print("카카오 로그인 여부 확인 성공")
                debugPrint(response)
                if response.value?.code == 5001 {
                    print("회원가입 필요 (from KaKaoDataManager)")
                    kakaoCompletion(false)
                }
                else if response.value?.code == 0 {
                    print("이미 회원가입 된 회원임 (from KaKaoDataManager")
                    // 재발급 받은 회원가입 토큰 유저디폴트에 저장
                    UserDefaults.standard.set(response.value!.data?.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(response.value!.data?.refreshToken, forKey: "refreshToken")
                    
                    kakaoCompletion(true)
                }
                
            case .failure(let error):
                print("카카오 로그인 여부 확인 실패")
                debugPrint(response)
                print(error)
            }
        }
//    return isKakaoLoggedIn
    }

}
