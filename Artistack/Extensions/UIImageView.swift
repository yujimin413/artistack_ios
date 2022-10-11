//
//  UIImageView.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/15.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async {
            [weak self] in
            if let url = url, let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "profile_image") // 추후 변경
                }
            }
        }
    }
    
    func setImage(with urlString: String?){
        if let urlStr = urlString { // " "을 받을 경우 체크하려고 임의 추가
            print("urlStr = urlString 에 들어왔다")
            ImageCache.default.retrieveImage(forKey: urlString!, options: nil) {
                result in
                switch result {
                case .success(let value) :
                    if let image = value.image {
                        // 캐시가 존재하는 경우
                        self.image = image
                    } else {
                        // 캐시가 존재하지 않는 경우
                        guard let url = URL(string: urlString!) else { return }
                        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                        self.kf.setImage(with: resource, options: [.transition(.fade(0.2))])
                    }
                case .failure(let error) :
                    print(error)
                }
            }
        }
        else {
            print("else문에 빠졌다")
            load(url: URL(string: urlString ?? " "))
        }
    }
}
