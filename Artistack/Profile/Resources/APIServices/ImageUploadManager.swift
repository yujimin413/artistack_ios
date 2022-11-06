//
//  imageUploadManager.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/15.
//

import Alamofire
import UIKit

class ImageUploadManager {
    func imageUploadManager(imageURL: URL?, _ completion: @escaping (String) -> Void) {
        let url = "https://dev.artistack.shop/upload/profile/?multiple=false"
//        var urlStr = ""
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageURL!, withName: "file", fileName: "imgfile.png", mimeType: "image/png")
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil).validate().responseDecodable(of: ImageModel.self) { response in
                switch response.result {
                    case .success(let result):
                        print("프로필 이미지 업로드 성공")
                        debugPrint(response)
                    print(response.value!.data)
                    let urlStr = response.value!.data
                    completion(urlStr)
                    
                    case .failure(let error):
                    print("프로필 이미지 업로드 실패")
                        print(error)
                    debugPrint(response)
                }
        }
//        return urlStr
    }
}
