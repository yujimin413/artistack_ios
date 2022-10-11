//
//  OutViewController.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/21.
//

import UIKit
import Alamofire
import KakaoSDKUser


class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    

    @IBAction func outButtonTapped(_ sender: Any) {
        
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
        expiredAt: Date(timeIntervalSinceNow: 60 * 3)
        )
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)

        let signinAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        let header : HTTPHeaders = ["Content-Type":"application/json;charset=UTF-8", "Authorization":"Bearer " + signinAccessToken!]
        
        AF.request("https://dev.artistack.shop/users/me",
                   method: .delete,
                   encoding: URLEncoding.default,
                   headers: header, interceptor: myAuthencitationInterceptor)
        .validate().responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let result):
                print("탈퇴 성공")
                debugPrint(response)
                
                // 유저디폴트 데이터 초기화
//                UserDefaults.standard.set(nil, forKey: "kakaoAccessToken")
                UserDefaults.standard.set(nil, forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "refreshToken")
//                print("유저디폴트 데이터 초기화")
//
//                // 연결끊기. 로그아웃 및 카카오 토큰 삭제
                UserApi.shared.unlink {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("unlink() success.")
                    }
                }
                
                // 앱 강제 종료
                exit(0)

                
                
                
            case .failure(let error):
                print("탈퇴 실패")
                // 실패.. 가 아니라 성공?
                
                // 유저디폴트 데이터 초기화
//                UserDefaults.standard.set(nil, forKey: "kakaoAccessToken")
                UserDefaults.standard.set(nil, forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "refreshToken")
                print("유저디폴트 데이터 초기화")

//                // 연결끊기. 로그아웃 및 카카오 토큰 삭제
                UserApi.shared.unlink {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("unlink() success.")
                    }
                }
                
                // 성공이면 위 코드 유지
                
                print(error)
                debugPrint(response)
                
                // 앱 강제 종료
                exit(0)
            }
        }
    }

}
