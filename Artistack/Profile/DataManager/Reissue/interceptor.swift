////
////  interceptor.swift
////  Artistack
////
////  Created by 임영준 on 2022/08/19.
////
//
//import Alamofire
//import Foundation
//
//final class MyRequestInterceptor: RequestInterceptor {
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
////        let accessToken = ProfileDataManager.AccessToken
//        print("@@@@@@호출됨@@@@@@@")
//        print(urlRequest)
//        guard urlRequest.url?.absoluteString.hasPrefix("https://dev.artistack.shop") == true
//               else {
//
//            print("@@@@@@들어옴@@@@@@@")
//
//                  completion(.success(urlRequest))
//                  return
//              }
//
//        var urlRequest = urlRequest
//        urlRequest.setValue("Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1MTgiLCJhcnRpc3RhY2tJZCI6Imxlb3Rlc3Q0Iiwibmlja25hbWUiOiJsZW9sZW8iLCJwcm92aWRlclR5cGUiOiJURVNUIiwicm9sZSI6IlVTRVIiLCJhdXRoIjoiVVNFUiIsImV4cCI6MTY2MDg5NDcwMH0.ZyUG0BClbOvvGi3neaEUZ3meNrxaBjAkXjPiZdFqD5r640pODZ2O2M14xqPpryVPx5n4l__CJSHg8mPNIFjHiw", forHTTPHeaderField: "Authorization")
//        print("@@@@@@지나옴@@@@@@@")
//
//        completion(.success(urlRequest))
//    }
//
//
//
//
//
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//
//        print("@@@@@@호출됨2222222@@@@@@@")
//
////        , response.statusCode == 401
//         guard let response = request.task?.response as? HTTPURLResponse else {
//
//             print("@@@@@@들어옴22222222@@@@@@@")
//             completion(.doNotRetryWithError(error))
//             return
//         }
//
//         let url = "https://dev.artistack.shop/oauth/reissue"
//         let headers: HTTPHeaders = [
//            "Content-Type" : "application/json"
//         ]
//
//
//
//        let parameter = ReissueInput(accessToken: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1MTgiLCJhcnRpc3RhY2tJZCI6Imxlb3Rlc3Q0Iiwibmlja25hbWUiOiJsZW9sZW8iLCJwcm92aWRlclR5cGUiOiJURVNUIiwicm9sZSI6IlVTRVIiLCJhdXRoIjoiVVNFUiIsImV4cCI6MTY2MDg5NDcwMH0.ZyUG0BClbOvvGi3neaEUZ3meNrxaBjAkXjPiZdFqD5r640pODZ2O2M14xqPpryVPx5n4l__CJSHg8mPNIFjHiw", refreshToken: "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2NjM0ODY1MjB9.3aoiIvgNEPJa6NouScO5UluBppo-7NtFZl92tiRBp-9L7cH80Xgw0mq1gUmOXOGSXoCjIuBBYegILDqXe9gd8w")
//
//
//        AF.request(url, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers).validate().responseDecodable(of: ReissueModel.self) { response in
//            switch response.result {
//                case .success(let result):
//                    print("재발급 성공")
//                    debugPrint(response)
//                case .failure(let error):
//                    print("재발급 실패")
//                    print(error)
//                debugPrint(response)
//                }
//
//
//
//
//
//
////        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ReissueModel.self) { response in
//////             let data = response.data
//////             let json = JSON(data!)
////
////             switch response.result{
////             case .success(_):
////                 print("제발 돼라")
////                 completion(.retry)
////             case .failure(let error):
////                 print("제발 안됨")
////                 debugPrint(response)
////                 completion(.doNotRetryWithError(error))
////             }
////
////         }
//    }
//}
//}
