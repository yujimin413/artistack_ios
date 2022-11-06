//
//  SignInViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/04.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices


class SignInViewController: UIViewController {
    @IBOutlet weak var stackYourArtTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        //        연결끊기!
        //        UserApi.shared.unlink {(error) in
        //            if let error = error {
        //                print(error)
        //            }
        //            else {
        //                print("unlink() success.")
        //            }
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("실행됐다")

        // 유효한 토큰 검사
        if (AuthApi.hasToken()) {
            print("들어왔다")
            
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        ("로그인 필요들어옴")

                    }
                    else {
                        ("print기타에러 들어옴")
                        //기타 에러
                    }
                }
                else {
                    print("accessTokenInfo() success.")
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    
                    // 이미 회원가입 된 경우
                    // 사용자 정보를 가져오고 화면전환
                    //                     KakaoAccessToken.sharedInstance().kakaoAccessToken = accessTokenInfo!
                    print("@@@  회원가입 분기 1 - 회원가입 O, 로그인 O  @@@")
                    print("이미 회원가입 됨, 로그인 불필요")
                    
                    // 회원가입 여부 확인 및 회원가입 토큰 UserInfo에 저장
                    self.checkKakaoLoggedIn() { isKakaoLoggedIn in
                        if isKakaoLoggedIn == true {
                            self.moveToHomeVC()
                        }
                        else {
                            // 회원가입 안 됨 -> 여기로 올 일 없음 없어야 함
                        }
                    }
                    
                }
            }
        }
        else {
            //로그인 필요
        }
    }
    
    @IBAction func kakaoLoginButtonDidTap(_ sender: Any) {
        // 카카오특 앱으로 접근
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("실행")
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("errorrrrrrrrrrr")
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something2
                    _ = oauthToken
                    
                    // accessToken
                    let accessToken = oauthToken?.accessToken
                    //                    KakaoAccessToken.sharedInstance().kakaoAccessToken = accessToken!
                    
                    //                    // 유저디폴트에 kakaoAccessToken 저장
                    UserDefaults.standard.set(accessToken, forKey: "kakaoAccessToken")
                    
                    print("카카오 어세스 토큰 from app")
                    print(accessToken)
                    
                    // 회원가입 여부 확인 및 회원가입 토큰 UserInfo에 저장
                    self.checkKakaoLoggedIn() { isKakaoLoggedIn in
                        if isKakaoLoggedIn == true {
                            print("@@@  (app) 회원가입 분기 2 - 회원가입 O, 로그인 X  @@@")
                            print("이미 회원가입 됨, 로그인 필요")
                            // 회원가입 토큰 UserInfo에 저장됨
                            self.moveToHomeVC()
                        }
                        else {
                            print("@@@  (app) 회원가입 분기 3 - 회원가입 X, 로그인 X  @@@")
                            print("회원가입 필요")
                            self.moveToSignInVC()
                        }
                    }
                }
            }
        }
        else {
            print("카카오톡 미설치")
            // 카카오톡 웹으로 접근
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                    
                    
                    // kakaoaccesstoken 변수에 넣어줌
                    //                    KakaoAccessToken.sharedInstance().kakaoAccessToken = accessToken!
                    
                    // 유저디폴트에 kakaoAccessToken 저장
                    UserDefaults.standard.set(accessToken, forKey: "kakaoAccessToken")
                    
                    print("카카오 어세스 토큰 입 니 다 ")
                    print(accessToken)
                    
                    // 회원가입 여부 확인 및 회원가입 토큰 UserInfo에 저장
                    self.checkKakaoLoggedIn() { isKakaoLoggedIn in
                        if isKakaoLoggedIn == true {
                            print("@@@  (web) 회원가입 분기 2 - 회원가입 O, 로그인 X  @@@")
                            print("이미 회원가입 됨, 로그인 필요")
                            // 회원가입 토큰 UserInfo에 저장됨
                            self.moveToHomeVC()
                        }
                        else {
                            print("@@@  (web) 회원가입 분기 3 - 회원가입 X, 로그인 X  @@@")
                            print("회원가입 필요")
                            self.moveToSignInVC()
                        }
                    }
                }
            }
        }
        
        
    }
    
    func checkKakaoLoggedIn(kakaoCompletion: @escaping (Bool) -> Void) {
        print("KakaoDataManager 호출")
        KakaoDataManager().kakaoDataManager(kakaoCompletion)
    }
    
    
    func moveToSignInVC() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                _ = user
                
                // 회원가입 화면으로 이동
                let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                backBarButtonItem.tintColor = .white
                self.navigationItem.backBarButtonItem = backBarButtonItem
                let FirstSignUpVC = UIStoryboard(name: "Signin", bundle: nil).instantiateViewController(withIdentifier: "FirstSignUpVC") as! FirstSignUpViewController
                self.present(FirstSignUpVC, animated: true, completion: nil)
            }
        }
    }
    
    
    func moveToHomeVC() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("이미 회원가입 됨")
                _ = user
                let TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                self.present(TabBarController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    
    @IBAction func appleLoginButtonDidTap(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    
    
    func setupAttribute() {
        // 행간 늘리기
        stackYourArtTextLabel.numberOfLines = 0
        let str = NSMutableAttributedString(string: stackYourArtTextLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        str.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, str.length))
        stackYourArtTextLabel.attributedText = str
        stackYourArtTextLabel.textAlignment = .center
    }
}




extension SignInViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let authorizationCode = appleIDCredential.authorizationCode
            let tokeStr = String(data: idToken, encoding: .utf8)
            let toString = String(decoding: authorizationCode!, as: UTF8.self)

            UserDefaults.standard.setValue(userIdentifier, forKey: "userIdentifier")
            UserDefaults.standard.setValue(true, forKey: "isAppleLogin")
            
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokeStr))")
            print("authorizationCode : " + toString)
            
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
