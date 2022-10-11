//
//  FinalSignUpViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/06.
//

import UIKit
import Alamofire

class FinalSignUpViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var agreeAllButton: UIButton!
    @IBOutlet weak var agreeServicesButton: UIButton!
    @IBOutlet weak var agreePersonalButton: UIButton!
    @IBOutlet weak var agreeMarketingButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var agreeServicesLabel: UILabel!
    @IBOutlet weak var agreePersonalLabel: UILabel!
    @IBOutlet weak var agreeMarketingLabel: UILabel!
    
    @IBOutlet weak var headTextLabel: UILabel!
    
    let bigDimondSelected = UIImage(named: "diamond_big_selected")
    let smallDimondSelected = UIImage(named: "diamond_small_selected")
    let bigDimondUnselected = UIImage(named: "diamond_big_unselected")
    let smallDimondUnselected = UIImage(named: "diamond_small_unselected")

    let doneButtonAbled = UIImage(named: "doneButton_abled")
    let doneButtonDisabled = UIImage(named: "doneButton_disabled")
    
    // 회원가입 유저 정보 저장 - API 전송
    var artistackId : String = ""
    var nickname : String = ""
    var bio : String = ""
    var profileImgUrl : URL!
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        
//        print(self.artistackId, self.nickname, self.profileImgUrl, self.bio)
    }
    
    func signInWithImg(completion: @escaping (String) -> Void) {
        // 회원가입 POST
        print("회원가입 w/ 프로필 이미지")
        ImageUploadManager().imageUploadManager(imageURL: self.profileImgUrl, completion)
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func doneButtonDidTap(_ sender: Any) {
        if profileImgUrl != URL(string: "") {
            print("프로필 이미지 업로드")
            signInWithImg() { urlStr in
                let params = UserInput(artistackId: self.artistackId,
                                      nickname: self.nickname,
                                      description: self.bio,
                                      providerType: "KAKAO",
                                       profileImgUrl: urlStr)
                UserDataManager().userDataManager(params)
            }
        }
        else {
            print("프로필 이미지 없이 회원 가입")
//            let noProfileImg = UIImage(named: "profile_image")
            let params = UserInput(artistackId: self.artistackId,
                                  nickname: self.nickname,
                                  description: self.bio,
                                  providerType: "KAKAO",
                                    profileImgUrl: "")
            UserDataManager().userDataManager(params)
        }

        // 화면 전환
        guard let FinishSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FinishSignUpVC") as? FinishSignUpViewController else { return }
        
        FinishSignUpVC.nickname = nickname

        FinishSignUpVC.modalTransitionStyle = .flipHorizontal
        FinishSignUpVC.modalPresentationStyle = .fullScreen
        
        self.present(FinishSignUpVC, animated: true, completion: nil)
    }

    @IBAction func agreeAllButtonDidTap(_ sender: Any) {
        if !agreeAllButton.isSelected {
            selectAllButtons()
        }
        else if agreeAllButton.isSelected {
            unSelectAllButtons()
        }
    }
    
    @IBAction func agreeServicesButtonDidTap(_ sender: Any) {
        if !agreeServicesButton.isSelected {
            agreeServicesButton.isSelected = true
            agreeServicesButton.setImage(smallDimondSelected, for: .normal)
            
            if agreePersonalButton.isSelected {
                doneButton.isEnabled = true
                doneButton.setImage(doneButtonAbled, for: .normal)
            }
            
            if checkAllButtonSelected() {
                agreeAllButton.isSelected = true
                agreeAllButton.setImage(bigDimondSelected, for: .normal)
            }
            
        }
        else if agreeServicesButton.isSelected {
            agreeAllButton.isSelected = false
            agreeServicesButton.isSelected = false
            
            agreeAllButton.setImage(bigDimondUnselected, for: .normal)
            agreeServicesButton.setImage(smallDimondUnselected, for: .normal)
            
            doneButton.isEnabled = false
            doneButton.setImage(doneButtonDisabled, for: .normal)
        }
    }
    
    @IBAction func agreePersonalButtonDidTap(_ sender: Any) {
        if !agreePersonalButton.isSelected {
            agreePersonalButton.isSelected = true
            agreePersonalButton.setImage(smallDimondSelected, for: .normal)
            
            if agreeServicesButton.isSelected {
                doneButton.isEnabled = true
                doneButton.setImage(doneButtonAbled, for: .normal)
            }
            
            if checkAllButtonSelected() {
                agreeAllButton.isSelected = true
                agreeAllButton.setImage(bigDimondSelected, for: .normal)
            }
            
        }
        else if agreePersonalButton.isSelected {
            agreeAllButton.isSelected = false
            agreePersonalButton.isSelected = false
            
            agreeAllButton.setImage(bigDimondUnselected, for: .normal)
            agreePersonalButton.setImage(smallDimondUnselected, for: .normal)
            
            doneButton.isEnabled = false
            doneButton.setImage(doneButtonDisabled, for: .normal)
        }
    }
    
    @IBAction func agreeMarketingButtonDidTap(_ sender: Any) {
        if !agreeMarketingButton.isSelected {
            agreeMarketingButton.isSelected = true
            agreeMarketingButton.setImage(smallDimondSelected, for: .normal)
            
            if checkAllButtonSelected() {
                agreeAllButton.isSelected = true
                agreeAllButton.setImage(bigDimondSelected, for: .normal)
            }
            
        }
        else if agreeMarketingButton.isSelected {
            agreeAllButton.isSelected = false
            agreeMarketingButton.isSelected = false
            
            agreeAllButton.setImage(bigDimondUnselected, for: .normal)
            agreeMarketingButton.setImage(smallDimondUnselected, for: .normal)
        }
    }
    
    
    // MARK: - Helpers
    func selectAllButtons() {
        agreeAllButton.isSelected = true
        agreeServicesButton.isSelected = true
        agreePersonalButton.isSelected = true
        agreeMarketingButton.isSelected = true
        
        agreeAllButton.setImage(bigDimondSelected, for: .normal)
        agreeServicesButton.setImage(smallDimondSelected, for: .normal)
        agreePersonalButton.setImage(smallDimondSelected, for: .normal)
        agreeMarketingButton.setImage(smallDimondSelected, for: .normal)
        
        doneButton.isEnabled = true
        doneButton.setImage(doneButtonAbled, for: .normal)
    }
    
    func unSelectAllButtons() {
        agreeAllButton.isSelected = false
        agreeServicesButton.isSelected = false
        agreePersonalButton.isSelected = false
        agreeMarketingButton.isSelected = false
        
        agreeAllButton.setImage(bigDimondUnselected, for: .normal)
        agreeServicesButton.setImage(smallDimondUnselected, for: .normal)
        agreePersonalButton.setImage(smallDimondUnselected, for: .normal)
        agreeMarketingButton.setImage(smallDimondUnselected, for: .normal)
        
        doneButton.isEnabled = false
        doneButton.setImage(doneButtonDisabled, for: .normal)
    }
    
    func checkAllButtonSelected() -> Bool {
        if agreeServicesButton.isSelected && agreePersonalButton.isSelected && agreeMarketingButton.isSelected {
            return true
        }
        return false
    }
    
    func setupAttribute() {
        // NSMutableAttributedString 타입으로 바꾼 text 저장
        let servicesStr = NSMutableAttributedString(string: agreeServicesLabel.text!)
        let personalStr = NSMutableAttributedString(string: agreePersonalLabel.text!)
        let marketingStr = NSMutableAttributedString(string: agreeMarketingLabel.text!)
        
        // 부분 색상 설정
        servicesStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_darkgrey") as Any, range: (agreeServicesLabel.text! as NSString).range(of: "(필수)"))
        servicesStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_lightgrey") as Any, range: (agreeServicesLabel.text! as NSString).range(of: "동의"))
        
        personalStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_darkgrey") as Any, range: (agreePersonalLabel.text! as NSString).range(of: "(필수)"))
        personalStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_lightgrey") as Any, range: (agreePersonalLabel.text! as NSString).range(of: "동의"))
        
        marketingStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_darkgrey") as Any, range: (agreeMarketingLabel.text! as NSString).range(of: "(선택)"))
        marketingStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_lightgrey") as Any, range: (agreeMarketingLabel.text! as NSString).range(of: "동의"))

        // 설정이 적용된 text를 label의 attributedText에 저장
        agreeServicesLabel.attributedText = servicesStr
        agreePersonalLabel.attributedText = personalStr
        agreeMarketingLabel.attributedText = marketingStr
        
        // headTextLabel 행간 설정
        let headStr = NSMutableAttributedString(string: headTextLabel.text!)
        let headParagraphStyle = NSMutableParagraphStyle()
        headParagraphStyle.lineSpacing = 6
        headStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: headParagraphStyle, range: NSMakeRange(0, headStr.length))
        headTextLabel.attributedText = headStr
    }
}
