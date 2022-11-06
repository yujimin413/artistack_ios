//
//  ProfileCollectionViewCell.swift
//  Artistack
//
//  Created by 유지민 on 2022/07/21.
//

import UIKit
import Alamofire

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"

    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileEditButton: UIButton!
    
    var index: Int = 0
    var delegate: ProfileCollectionViewCellDelegate?
//    var imgDelegate: callProfilePhotoEditVC?
    
    var test = ""
    var imgStr = ""
    
    @IBAction func profileEditButtonDidTap(_ sender: Any) {
        print("send current profile")
        self.delegate?.profileEditButtonDidTap(index: index, imgStr: self.imgStr, img: profileImageView.image!, name: nameLabel, bio: bioLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAttribute()
//        getProfileInfo()
    }
    
    func getProfileInfo(_ viewController: ProfileViewController) {
        // 프로필 정보 GET
        print("프로필 정보 GET")
        
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

        let url = "https://dev.artistack.shop/users/me"
        let signinAccessToken = UserDefaults.standard.string(forKey: "accessToken")
        let header : HTTPHeaders = ["Content-Type":"application/json;charset=UTF-8", "Authorization":"Bearer " + signinAccessToken!]
        
        print("프로필 정보 GET 지나옴,,,")

        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header, interceptor: myAuthencitationInterceptor)
        .validate().responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let result):
                print("나의 프로필 조회 성공")
                debugPrint(response)
                
//                if ProfileModel.value!data.profileImgUrl != nil {
//
//                }
//                print(self.nameLabel.text!)
//                print(response.value!.data.nickname)
                
//                var test = response.value!.data.nickname
//                print(test)
                self.imgStr = response.value!.data.profileImgUrl
                let imgUrl = URL(string: response.value!.data.profileImgUrl)
//                if imgUrl != nil {
//                    print("이미지유아렐~~~~")
//                    print((imgUrl))
//                    if let img = try? Data(contentsOf: imgUrl!) {
//                        self.profileImageView.image = UIImage(data: img)
//                    }
//                }
                if self.imgStr != "" {
                    DispatchQueue.global().async { [weak self] in
                               if let data = try? Data(contentsOf: imgUrl!) {
                                   if let image = UIImage(data: data) {
                                       DispatchQueue.main.async {
                                           self?.profileImageView.image = image
                                       }
                                   }
                               }
                           }
                }
                else {
                    self.profileImageView.image = UIImage(named: "profile_image")
                }
    
                self.nameLabel.text! = response.value!.data.nickname
                self.usernameLabel.text! = "@" + response.value!.data.artistackId
                self.bioLabel.text! = response.value!.data.description
//                self.profileImageView.image = self.imgStr
                
                // 프로필 리로드
//                viewController.myProfileReload(self)

            case .failure(let error):
                print("나의 프로필 조회 실패")
                print(error)
            }
            
            
            print("마지막chekck")
            
        }
    }
    
    func setupAttribute() {
        // 프로필 마름모
        profileBackgroundView.addDiamondMask()
        profileImageView.addDiamondMask()
        
//        // text 크기 자동 조절
//        nameLabel.sizeToFit()
//        usernameLabel.sizeToFit()
//        bioLabel.sizeToFit()
//        if self.nameLabel.adjustsFontSizeToFitWidth == false {
//            self.nameLabel.adjustsFontSizeToFitWidth = true
//        }
//        if self.usernameLabel.adjustsFontSizeToFitWidth == false {
//            self.usernameLabel.adjustsFontSizeToFitWidth = true
//        }
//        if self.bioLabel.adjustsFontSizeToFitWidth == false {
//            self.bioLabel.adjustsFontSizeToFitWidth = true
//        }
    }
}

// 이미지뷰 다이아몬드 모양으로
extension UIView {
    func addDiamondMask(cornerRadius: CGFloat = 0) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + cornerRadius))
        path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - cornerRadius))
        path.addLine(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.midY))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = cornerRadius * 2
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round

        layer.mask = shapeLayer
    }
}

// 커스텀 컬러
extension UIColor {
   // static let profile_background: UIColor = UIColor(named: "profile_background")!
    class var profile_border: UIColor? { return UIColor(named: "profile_border") }
}
