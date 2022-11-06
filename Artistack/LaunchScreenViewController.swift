//
//  LaunchScreenViewController.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {

        
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
//        UserDefaults.standard.set(nil, forKey: "kakaoAccessToken")
        super.viewDidLoad()
        initTest()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
             super.viewWillAppear(animated)
            print("하이하이")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if self.appDelegate?.isLogin == true {
                    self.presentToMain()
                } else {
                    self.presentToLogin()
                }
            }
        }
    
    func initTest(){
        print("카카오어세스토큰 \(UserDefaults.standard.string(forKey: "kakaoAccessToken"))")
        print("AccessToken \(UserDefaults.standard.string(forKey: "accessToken"))")
        print("refreshToekn \(UserDefaults.standard.string(forKey: "refreshToken"))")
    }
    
    
    
        
        // MARK: - Functions
        private func presentToMain() {
            print("presentToMain 호출됨")
            guard let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else { return }
            mainVC.modalPresentationStyle = .fullScreen
            mainVC.modalTransitionStyle = .crossDissolve
            self.present(mainVC, animated: true, completion: nil)
        }
        
        private func presentToLogin() {
            guard let loginVC = UIStoryboard(name: "Signin", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController else { return }
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true, completion: nil)
        }

}
