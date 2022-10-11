//
//  HomeDataManager.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/09.
//

import Foundation
import Alamofire

class HomeDataManager {
    
    let baseUrl = "https://dev.artistack.shop/"

    /*
    func authorize() {
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
    }*/
    
    /*
    func isValidPost(data: Data) -> PostInfo {
        //let decoder = JSONDecoder()
        guard let decodedData = try? JSONDecoder().decode(PostInfo.self, from: data) else { return }
        return decodedData
    }
    */
    
    /*
    func homeDataAllManager() async throws -> [EachProject?] {
        print("[async await] homeDataAllManager 함수 실행")
        let url = baseUrl + "projects/search?page=0&size=10&sort=id,desc" //lastId queryString 넣어줘야
        return try await withCheckedContinuation { (continuation: CheckedContinuation<[EachProject?], Never>) in
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseDecodable(of: Project.self){
                response in
                switch response.result {
                case .success(let result) :
                    continuation.resume(returning: (response.value?.data!.content)!)
                    return
                case .failure(let error) :
                    return
                }
            }
        }
     */
        /*
        try await withUnsafeThrowingContinuation { continuation in
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseDecodable(of: Project.self){ response in
                switch response.result {
                case .success(let result) :
                    continuation.resume(returning: response.value.data)
                    return
                case .failure(let error) :
                    continuation.resume(throwing: error)
                    return
                }
                fatalError("should not get here")
            }
        }
    }*/
    
    
    func homeDataAllManager(completion: @escaping (_ data: [EachProject?]) -> Void) {
        
        //authorize()
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        //DispatchQueue.global().sync {
            print("homeDataAllManager 함수 실행")
            let url = baseUrl + "projects/search?page=0&size=10&sort=id,desc" //lastId queryString 넣어줘야
            // 추후 헤더 필요할 예정 : API Sheet 참고
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Project.self){ response in
                print("response.result : ", response.result)
                print("response.value : ", response.value)
                switch response.result {
                case .success(let result) :
                    print(result)
                    completion(response.value!.data!.content)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        //}
    }
    
    
    /*
    func homeDataInfoManager(projectId: Int) async throws -> PostInfo {
        print("[async await] homeDatInfoManager 함수 실행")
        let url = baseUrl + "projects/" + String(projectId)
        return try await withCheckedContinuation { (continuation: CheckedContinuation<PostInfo, Never>) in
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseDecodable(of: Post.self){
                response in
                switch response.result {
                case .success(let result) :
                    continuation.resume(returning: response.value!.data)
                    return
                case .failure(let error) :
                    return
                }
            }
        }
    }
    */
    
    // projects가 아무것도 없을 때 - 0이라는 인자를 넘겨주도록 설정해놓음. 그러나 0이라는 인자를 넘겼을 때에 대한 명령문은 없는 상태.
    func homeDataInfoManager(projectId: Int, completion: @escaping(_ data : PostInfo) -> Void) {
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        //DispatchQueue.global().sync {
            print("homeDataInfoManager 함수 실행")
            let url = baseUrl + "projects/" + String(projectId)
            // 추후 헤더 필요할 예정 : API Sheet 참고
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Post.self){ response in
            //dataRequest.responseData { response in
                //print("response.result : ", response.result)
                //print("response.value : ", response.value)
                switch response.result {
                case .success(let result) :
                    print(result) // 현재 임시 진행 // homeviewcontroller 와 연결 등 진행
                    //let res = self.isValidPost(data: response.data!)
                    completion(response.value!.data)
                case .failure(let error) :
                    print(error.localizedDescription)
                    //completion(nil)
                    return
                }
            }
        //}
    }
    
        
    func stackInfoManager(projectId: Int, sequence: String, query: String, completion: @escaping(_ data: [EachStack?]) -> Void) {
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        print("stackInfoManager 함수 실행")
        let url = baseUrl + "projects/" + String(projectId) + "/" + sequence + "?current=" + query + "&page=0"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Stack.self) { response in
            //print("response.result : ", response.result)
            //print("response.value : ", response.value)
            switch response.result {
            case .success(let result) :
                print(result)
                completion(response.value!.data!.content)
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func postLikeManager(projectId: Int) {
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        print("postLikeManager 함수 실행")
        let url = baseUrl + "projects/" + String(projectId) + "/like"
        AF.request(url, method: .post, parameters: nil, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Like.self) { response in
            switch response.result {
            case .success(let result) :
                print("postLikeManager 함수 정상 실행")
                return
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func postUnlikeManager(projectId: Int) {
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        print("postUnlikeManager 함수 실행")
        let url = baseUrl + "projects/" + String(projectId) + "/like"
        AF.request(url, method: .delete, parameters: nil, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: Like.self) { response in
            switch response.result {
            case .success(let result) :
                print("postUnLikeManager 함수 정상 실행")
                return
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func likedPeopleListManager(projectId: Int, completion: @escaping(_ data: [Person?]) -> Void){
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: UserDefaults.standard.string(forKey: "accessToken")!,
                                                    refreshToken: UserDefaults.standard.string(forKey: "refreshToken")!,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 3))

        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        let signInAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        var header : HTTPHeaders = [
            "Content-Type":"application/json;charset=UTF-8",
            "Authorization": "Bearer " + (signInAccessToken ?? " ") ]
        
        print("likedPeopleListManager 함수 실행")
        let url = baseUrl + "projects/" + String(projectId) + "/like/users"
        AF.request(url, method: .get, parameters: nil, headers: header, interceptor: myAuthencitationInterceptor).validate(statusCode: 200..<300).responseDecodable(of: LikedList.self) { response in
            switch response.result {
            case .success(let result) :
                print(result)
                completion(response.value!.data!.content)
                return
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}
