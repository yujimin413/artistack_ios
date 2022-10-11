//
//  AppDelegate.swift
//  Artistack
//
//  Created by csh on 2022/07/10.
//

import UIKit
import KakaoSDKCommon
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser



@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var isLogin : Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        print("시작")
        KakaoSDK.initSDK(appKey: "a91b29c936bfafab2ae601ff493d1233")
        
        let acToken = UserDefaults.standard.string(forKey: "userIdentifier")
        print(acToken)
        
        if acToken != nil {
                if false {
                    // 애플 로그인으로 연동되어 있을 때, -> 애플 ID와의 연동상태 확인 로직
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: "userIdentifier") ?? "") { (credentialState, error) in
                        switch credentialState {
                        case .authorized:
                            print("해당 ID는 연동되어있습니다.")
                            self.isLogin = true
                        case .revoked:
                            print("해당 ID는 연동되어있지않습니다.")
                            self.isLogin = false
                        case .notFound:
                            print("해당 ID를 찾을 수 없습니다.")
                            self.isLogin = false
                        default:
                            break
                        }
                    }
                } else {
                    print("else 들어옴!")
                    if AuthApi.hasToken() {     // 유효한 토큰 존재
                        UserApi.shared.accessTokenInfo { (_, error) in
                            if let error = error {
                                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                                    self.isLogin = false
                                }
                            } else {
                                // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                                print("두번째 else 들어옴!")
                                //여기서 카카오 로그인 해줘야하네
                                self.checkKakaoLoggedIn { Bool in
                                    if Bool == true {
                                        print("hi")
                                        self.isLogin = true
                                    }
                                    else{
                                        self.isLogin = false
                                    }
                                }
                            }
                        }
                    } else {
                        // 카카오 토큰 없음 -> 로그인 필요
                        self.isLogin = false
                    }
                }
            } else {
                self.isLogin = false    // acToken 값이 nil일 때 -> 로그인 뷰로
            }
        return true
    }
    
    
    
    func checkKakaoLoggedIn(kakaoCompletion: @escaping (Bool) -> Void) {
        print("KakaoDataManager 호출")
        KakaoDataManager().kakaoDataManager(kakaoCompletion)
    }
    
    
    
    
    
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    

    
    
    
    
    


}

