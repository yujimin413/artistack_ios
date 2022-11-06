//
//  MyprojectDataManager.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/18.
//

import Alamofire
import Foundation

class MyprojectDataManager {
    // 내 게시글 조회
    
    
    
    func getMyProject(_ viewController: ProfileViewController, completion: @escaping(_ data : data2)->Void) {
        
        guard let acToken = UserDefaults.standard.string(forKey: "accessToken")
            else
            {
                print("MyprojectDataManager에서 어세스 토큰 nil 확인")
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
            "Contend-Type" : "application/json;charset=UTF-8",
            "Authorization" : "Bearer " + signInAccessToken!]
        
        let page : Int = 0
        let size : Int = 30
        let sort : String = "id,desc" // 최신순
        
        AF.request("https://dev.artistack.shop/projects/me?page=\(page)&size=\(size)&sort=\(sort)",
                   headers: header, interceptor: myAuthencitationInterceptor).validate().responseDecodable(of: MyprojectDataModel.self) { response in
            switch response.result {
                case .success(let result):
                
                completion(result.data!)
                    print("내 프로젝트 조회 성공")
                    debugPrint(response)

                viewController.suuccessFeedAPI(result)

//                    debugPrint(response)
                case .failure(let error):
                    print("내 프로젝트 조회 실패")
                    print(error)
                debugPrint(response)
                }
        }
    }

            // 내 게시글 삭제
            func deleteMyPost(_ viewController: ProfileViewController, _ projectId: Int) {
                
                let url = "https://dev.artistack.shop/projects/\(projectId)"
                
                guard let acToken = UserDefaults.standard.string(forKey: "accessToken")
                    else
                    {
                        print("MyprojectDataManager에서 어세스 토큰 nil 확인")
                        return
                    }
                
                let authenticator = MyAuthenticator()
                let credential = MyAuthenticationCredential(accessToken: acToken,
                                                            refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                            expiredAt: Date(timeIntervalSinceNow: 60 * 120))
                let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                            credential: credential)
                
                
                let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
                
                let header : HTTPHeaders = [
                    "Contend-Type" : "application/json;charset=UTF-8",
                    "Authorization" : "Bearer " + signInAccessToken!]
                
                AF.request(url,
                           method: .delete,
                           headers: header, interceptor: myAuthencitationInterceptor).validate().responseDecodable(of: MyprojectDeleteDataModel.self) { response in
                    switch response.result {
                        case .success(let result):
                            print("내 프로젝트 삭제 성공")
        //                    debugPrint(response)
                        case .failure(let error):
                            print("내 프로젝트 삭제 실패")
                            print(error)
        //                debugPrint(response)
                        }
                }
            }
        }

