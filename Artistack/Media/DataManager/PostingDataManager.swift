//
//  PostingDataManager.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/10.
//




import Alamofire
import Foundation
import simd

class PostingUploadDataManager {

    //필요한거: IsStack 여부와 userID
    
    var isStack : Bool = false
    var userID : String = "0"
    
    
    func posting(imageURL: URL?, parameter: dto) {
        
        
        if(isStack == true)
        {
            userID = RecordingViewController.ProjectID!
        }
        
        
        
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        
        var URL = "https://dev.artistack.shop/projects/\(userID)"
        
        //토큰, Content-Type 설정
        let header : HTTPHeaders = [
                "Content-Type" : "application/json",
                "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "accessToken")!)"]
        
        print(parameter)
        
        //구조체를 JSON형식으로 encode
        let data = try? JSONEncoder().encode(parameter)
        if let data = data, let dataString = String(data: data, encoding: .utf8){
        print(dataString)
        }
            let parameters = [
                "dto" : data
            ]
        
        //Multipart형태로 전송을 위해 upload사용
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value!, withName: key, mimeType: "application/json")
            }
            multipartFormData.append(imageURL!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
        }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header, interceptor: myAuthencitationInterceptor).validate().response { response in
            debugPrint(response)
            guard let statusCode = response.response?.statusCode,
                  statusCode == 200
            else {
                print("포스팅실패")
                debugPrint(response)
                return }
        }
    }
}
    

