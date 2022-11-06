//
//  ProfileEditViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/07/27.
//

import UIKit
import Foundation   // 정규표현식 매칭여부 검사
import Alamofire

//protocol callProfileEditVC {
//    func profileUpdated(img: UIImage, name: UITextField, bio: UITextView)
//}

class ProfileEditViewController: UIViewController , callProfilePhotoEditVC {
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var profilePhotoEditButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var nicknameWarningbox: UIImageView!
    @IBOutlet weak var nicknameTextCount: UILabel!
    @IBOutlet weak var introTextCount: UILabel!
    @IBOutlet weak var introTextCountTotal: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var topLine: UIImageView!
    @IBOutlet weak var middleLine: UIImageView!
    @IBOutlet weak var bottomLine: UIImageView!
    @IBOutlet weak var backgroundBlackView: UIView!
    
    var placeholderLabel: UILabel!
//    var imgDelegate: callProfileEditVC?
    
    // 내프로필화면에서 기존 프로필사진, 닉네임, 소개 정보 받아오기 위한 프로퍼티 선언
    var profileImgStr : String = ""
    var profileImg: UIImage? = nil
    var nicknameTxt: String = ""
    var bioTxt: String = ""
    
    var imageUrl : URL!
    
    let saveButtonDisabledImage = UIImage(named: "savebutton_disabled")
    let saveButtonAbledImage = UIImage(named: "savebutton_abled")
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        TabBarController.actionButton.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TabBarController.actionButton.isHidden = false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            guard let profilePhotoEditVC: ProfilePhotoEditViewController = segue.destination as? ProfilePhotoEditViewController else { return }
            profilePhotoEditVC.delegate = self
        }
    }
    
    // MARK: - Actions
    func profileImageSend(data: UIImage, imgUrl: URL) {
        print("sent proifleimage")
        profileImageView.image = data
        imageUrl = imgUrl
        
        // 저장버튼 활성화
        saveButton.setImage(saveButtonAbledImage, for: .normal)
        saveButton.isEnabled = true
    }
    
    func profileEditWithImg(completion: @escaping (String) -> Void) {
        // 프로필 이미지 전송
        print("프로필 수정 w/ 이미지")
        print(imageUrl)
        ImageUploadManager().imageUploadManager(imageURL: imageUrl, completion)
    }

    @IBAction func saveButtonDidTap(_ sender: Any) {
        
        // 나의 프로필 수정사항 PATCH
        var editedNickname : String?
        var editedDescription : String?
//        var editedProfileImgUrl : String?
        
        if nicknameTextField.text != nicknameTxt {
            print("닉네임 수정")
            editedNickname = nicknameTextField.text!
        }

        if introTextView.text != bioTxt {
            print("소개 수정")
            editedDescription = introTextView.text.filter { !$0.isNewline }
//            editedDescription = introTextView.text!
        }
        
        if  profileImageView.image != profileImg {
            print("이미지 수정")
            profileEditWithImg() { urlStr in
                let params = ProfileEditInput(nickname: editedNickname,
                                              description: editedDescription,
                                              profileImgUrl: urlStr)
                ProfileEditDataManager().profileEditDataManager(params)
                
            }
            
        }
  
        else {
            print("이미지 수정 안 함")
            let params = ProfileEditInput(nickname: editedNickname, description: editedDescription)
            ProfileEditDataManager().profileEditDataManager(params)
        }
        
        
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // nicknameTextField 에 입력된 텍스트에 따라 UI 업데이트
    @objc private func textDidChange(_ notification: Notification) {
            placeholderLabel.isHidden = !introTextView.text.isEmpty
        // 한 글자 입력할 때마다 실행

            // 글자수 세기
            self.nicknameTextCount.text = "\(self.nicknameTextField.text!.count)"
            self.introTextCount.text = "\(self.introTextView.text!.count)"
        
            if let textField = notification.object as? UITextField {
                // nicknameTextField
                if let text = nicknameTextField.text {
//                    let isValidnickname = text.range(of: "^[a-z0-9_]{0,}$", options: .regularExpression) != nil     // 유효성 검사
                    
                    if text.count >= 14 {
                        // 14글자 넘어가면 자동으로 키보드 내려감
                        textField.resignFirstResponder()
                    }
                    else if text.count >= 1 && text.count <= 14{
                        saveButton.setImage(saveButtonAbledImage, for: .normal)
                        saveButton.isEnabled = true
                    }
                    else {
                        nicknameWarningbox.isHidden = false
                        saveButton.setImage(saveButtonDisabledImage, for: .normal)
                        saveButton.isEnabled = false
                    }

                    // 초과되는 텍스트 제거
//                    if text.count >= 14 {
//                        let index = text.index(text.startIndex, offsetBy: 14)
//                        let newString = text[text.startIndex..<index]
//                        textField.text = String(newString)
//                    }

                    // 0자 초과 && 4자 미만 || 영문소문자,숫자,밑줄기호 이외의 문자 입력될 경우 경고박스 띄우기
//                    else if text.count > 0 && text.count < 4 || !isValidnickname {
//                        nicknameWarningbox.isHidden = false
//                        changeConstraints()
//
//                        saveButton.setImage(saveButtonDisabledImage, for: .normal)
//                        saveButton.isEnabled = false
//                    }
//                    else {
//                        nicknameWarningbox.isHidden = true
//                        setContraints()
//
//                        saveButton.setImage(saveButtonAbledImage, for: .normal)
//                        saveButton.isEnabled = true
//                    }
                }
            }
            // introTextView
            else if let textView = notification.object as? UITextView {
                if let text = introTextView.text {
                    // 38글자 넘어가면 자동으로 키보드 내려감
                    if text.count >= 38 {
                        textView.resignFirstResponder()
                    }
                    else {
                        saveButton.setImage(saveButtonAbledImage, for: .normal)
                        saveButton.isEnabled = true
                    }
                }
            }
        }
    
    // MARK: - Helpers
    private func setupAttribute() {
        // 프로필 사진 다이아몬드 모양
        profileImageView.addDiamondMask()
        profileBackgroundView.addDiamondMask()
        backgroundBlackView.addDiamondMask()
        
        // textField delegate 연결
        nicknameTextField.delegate = self
        introTextView.delegate = self
        
        // 내프로필화면에서 기존 프로필사진, 닉네임, 소개 정보 받아오기
        profileImageView.image = profileImg
        nicknameTextField.text = nicknameTxt
        introTextView.text = bioTxt
        
        // 초기 글자수
        self.nicknameTextCount.text = "\(self.nicknameTextField.text!.count)"
        self.introTextCount.text = "\(self.introTextView.text!.count)"
        
        saveButton.isEnabled = false
        
        // NotificationCenter에 textDidChange 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nicknameTextField)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: introTextView)
        
        // introTetView의 placeHolder 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(introTextViewDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
        placeholderLabel = UILabel()
        placeholderLabel.text = "스태커님은 어떤 음악을 하시나요?"
        placeholderLabel.font = UIFont.systemFont(ofSize: (introTextView.font?.pointSize)!)
        introTextView.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.init(named: "textCount_grey")
        placeholderLabel.isHidden = !introTextView.text.isEmpty
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 0, y: (introTextView.font?.pointSize)! / 2)
        
        introTextView.textContainer.lineFragmentPadding = 0
        
        
        
    }
    
    @objc private func introTextViewDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
}

// nicknameTextField
extension ProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 한 글자 입력할 때마다 실행
        let maxString = 14
        // 글자수 최대 넘어가면 입력 안 받도록
        if !(textField.text?.isEmpty ?? true){
            return textField.text!.count +  (string.count - range.length) <= maxString
        }
        return true
    }
}

// introTextView
extension ProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let maxString = 38
        if !(textView.text?.isEmpty ?? true){
            return textView.text!.count +  (text.count - range.length) <= maxString
        }
        return true
    }

}

// 커스텀 컬러
//extension UIColor {
//    class var textCount_grey: UIColor? { return UIColor(named: "textCount_grey") }
//}
