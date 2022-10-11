//
//  SecondSignUpViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/06.
//

import UIKit

class SecondSignUpViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var warningTextLabel: UILabel!
    @IBOutlet weak var headTextLabel: UILabel!
    
    var nextButton: UIButton!
    var nextBarButton: UIBarButtonItem!
    
    let nextButtonDisabled = UIImage(named: "signup_next_disabled")
    let nextButtonAbled = UIImage(named: "signup_next_abled")
    
    // 넘겨받을 회원가입 유저 정보 - for API 전송
    var artistackId : String = ""

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        
//        print(artistackId)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc func nextButtonDidTap (){
//        self.view.endEditing(true)
//        print("tapped")
//        guard let ThirdSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdSignUpVC") as? ThirdSignUpViewController else { return }
//
//        ThirdSignUpVC.modalTransitionStyle = .coverVertical
//        ThirdSignUpVC.modalPresentationStyle = .fullScreen
//
//        self.present(ThirdSignUpVC, animated: true, completion: nil)

        
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backBarButtonItem.tintColor = .white
//        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let ThirdSignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdSignUpVC") as! ThirdSignUpViewController
        ThirdSignUpVC.artistackId = artistackId
        ThirdSignUpVC.nickname = nicknameTextField.text!
        
        self.present(ThirdSignUpVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(ThirdSignUpVC, animated: true)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        // 한 글자 입력할 때마다 실행
        
                // nicknameTextField
                if let text = nicknameTextField.text {
                    
                    // 유효성 검사
//                    let isValidID = text.range(of: "^[a-z0-9_]{0,}$", options: .regularExpression) != nil
                    
//                    if text.count >= 14 {
//                        // 14글자 넘어가면 자동으로 키보드 내려감
//                        textField.resignFirstResponder()
//                    }
                    
                    if text.count >= 1 && text.count <= 14 {
                        warningTextLabel.textColor = UIColor.init(named: "warning_text_grey")
                        nextButton.setImage(nextButtonAbled, for: .normal)
                        
                        nextButton.isEnabled = true
                                        
                    }
                    
                    else {
                        warningTextLabel.textColor = .red
                        nextButton.setImage(nextButtonDisabled, for: .normal)

                        nextButton.isEnabled = false
                    }
                // 초과되는 텍스트 제거
//                    if text.count >= 14 {
//                        let index = text.indôx(text.startIndex, offsetBy: 14)
//                        let newString = text[text.startIndex..<index]
//                        textField.text = String(newString)
//                }

        }
    }
  
    // MARK: - Helpers
    func setupAttribute() {
        // textField delegate 연결
//        idTextField.delegate = self
        
        // NotificationCenter에 textDidChange 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nicknameTextField)
        
        let toolBar = UIToolbar()
        toolBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 54 / 844)
        nextButton = UIButton.init(type: .custom)
        nextButton.setImage(nextButtonDisabled, for: .normal)
//        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        nextButton.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 54 / 844)
        toolBar.barTintColor = .clear
        
         nextBarButton = UIBarButtonItem.init(customView: nextButton)
        toolBar.items = [nextBarButton]
        nextBarButton.isEnabled = false

        nicknameTextField.inputAccessoryView = toolBar
        
        // expTextLabel 행간 설정
        let headStr = NSMutableAttributedString(string: headTextLabel.text!)
        let headParagraphStyle = NSMutableParagraphStyle()
        headParagraphStyle.lineSpacing = 6
        headStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: headParagraphStyle, range: NSMakeRange(0, headStr.length))
        headTextLabel.attributedText = headStr
    }

}

// 커스텀 컬러
//extension UIColor {
//    class var warningText_grey: UIColor? { return UIColor(named: "warning_text_grey") }
//    class var screen_navy: UIColor? { return UIColor(named: "screen_navy") }
//}
