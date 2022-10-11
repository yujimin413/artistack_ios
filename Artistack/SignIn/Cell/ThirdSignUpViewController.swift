//
//  ThirdSignUpViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/06.
//

import UIKit

class ThirdSignUpViewController: UIViewController, callProfilePhotoSetVC {
    // MARK: - Properties
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBlackView: UIView!
    @IBOutlet weak var editCameraEditButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var introTextCount: UILabel!
    @IBOutlet weak var headTextLabel: UILabel!
    
    var placeholderLabel: UILabel!
    
    let nextButtonDisabledImage = UIImage(named: "nextButton_disabled")
    let nextButtonAbledImage = UIImage(named: "nextButton_abled")
    
    // 회원가입 유저 정보 저장 - API 전송
    var artistackId : String = ""
    var nickname : String = ""
    
    var imageUrl : URL!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        
//        print(artistackId)
//        print(nickname)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCameraButtonDidTap" {
            guard let ProfilePhotoSetVC: ProfilePhotoSetViewController = segue.destination as? ProfilePhotoSetViewController else { return }
            ProfilePhotoSetVC.delegate = self
        }
    }
    
    // MARK: - Actions
    func profileImageSet(data: UIImage, imageUrl imgUrl: URL) {
        print("sent profileImage")
        profileImageView.image = data
        imageUrl = imgUrl
        
        // 다음버튼 활성화
        nextButton.setImage(nextButtonAbledImage, for: .normal)
        nextButton.isEnabled = true
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
//        guard let FinalSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalSignUpVC") as? FinalSignUpViewController else { return }
//
//        FinalSignUpVC.modalTransitionStyle = .coverVertical
//        FinalSignUpVC.modalPresentationStyle = .fullScreen
//
//        self.present(FinalSignUpVC, animated: true, completion: nil)
        
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backBarButtonItem.tintColor = .white
//        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
        let FinalSignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalSignUpVC") as! FinalSignUpViewController
        FinalSignUpVC.nickname = nickname
        FinalSignUpVC.artistackId = artistackId
        FinalSignUpVC.bio = introTextView.text.filter { !$0.isNewline }
        FinalSignUpVC.profileImgUrl = imageUrl
        
//        FinalSignUpVC.profileImgUrl = (self.profileImageView.image!.pngData()?.base64EncodedString())!
//        print((self.profileImageView.image!.pngData()?.base64EncodedString())!)
        
        self.present(FinalSignUpVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(FinalSignUpVC, animated: true)
    }
    
    // introTextView에 입력된 텍스트에 따라 UI 업데이트, 한 글자 입력할 때마다 실행
    @objc private func textDidChange(_ notification: Notification) {
            placeholderLabel.isHidden = !introTextView.text.isEmpty
        
            // 글자수 세기
            self.introTextCount.text = "\(self.introTextView.text!.count)"

             if let textView = notification.object as? UITextView {
                if let text = introTextView.text {
                    // 38글자 넘어가면 자동으로 키보드 내려감
                    if text.count >= 38 {
                        textView.resignFirstResponder()
                    }
                    else {
                        nextButton.setImage(nextButtonAbledImage, for: .normal)
                        nextButton.isEnabled = true
                    }
                }
            }
    }
    
    @objc private func introTextViewDidTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func jumpButtonDidTap(_ sender: Any) {
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backBarButtonItem.tintColor = .white
//        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let FinalSignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinalSignUpVC") as! FinalSignUpViewController
        
        FinalSignUpVC.nickname = nickname
        FinalSignUpVC.artistackId = artistackId
        FinalSignUpVC.bio = introTextView.text!
        
        self.present(FinalSignUpVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(FinalSignUpVC, animated: true)
    }
    
    // MARK: - Helpers
    func setupAttribute() {
        // 다이아몬드 모양
        profileBackgroundView.addDiamondMask()
        profileImageView.addDiamondMask()
        profileBlackView.addDiamondMask()
        
        // textView delegate 연결
        introTextView.delegate = self
        
        // 초기 글자수
        self.introTextCount.text = "\(self.introTextView.text!.count)"
        
        // NotificationCenter에 textDidChange 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: introTextView)
        
        // introTetView의 placeHolder 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(introTextViewDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 2
        placeholderLabel.text = "어떤 음악을 하시는지 소개해주세요! \nEx ) 기타와 피아노치는것을 좋아합니다."
        placeholderLabel.font = UIFont.systemFont(ofSize: (introTextView.font?.pointSize)!)
        introTextView.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.init(named: "warning_text_grey")
        placeholderLabel.isHidden = !introTextView.text.isEmpty
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (introTextView.font?.pointSize)! / 2)
        
        // headTextLabel 행간 설정
        let headStr = NSMutableAttributedString(string: headTextLabel.text!)
        let headParagraphStyle = NSMutableParagraphStyle()
        headParagraphStyle.lineSpacing = 6
        headStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: headParagraphStyle, range: NSMakeRange(0, headStr.length))
        headTextLabel.attributedText = headStr
    }

}

// introTextView
extension ThirdSignUpViewController: UITextViewDelegate {
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
