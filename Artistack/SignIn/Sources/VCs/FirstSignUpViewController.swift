//
//  FirstSignUpViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/06.
//


// Trouble Shotting
// 1. 아무 입력 안 해도 다음 버튼 눌림
// 2. warningText_grey 컬러 적용 안 됨

import UIKit
import Alamofire

class FirstSignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var headTextLabel: UILabel!
    @IBOutlet weak var expTextLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var warningTextLabel: UILabel!
    
    var nextButton: UIButton!
    var nextBarButton: UIBarButtonItem!
    
    let nextButtonDisabled = UIImage(named: "signup_next_disabled")
    let nextButtonAbled = UIImage(named: "signup_next_abled")
    
//    // 회원가입 유저 정보 저장 - API 전송
//    public var artistackId = ""
//    public var nickname = ""
//    public var bio = ""
//    public var providerType = ""
//    public var profileImgUrl = ""
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
    }
    
    // MARK: - Actions
    @objc func nextButtonDidTap () {
//        self.view.endEditing(true)
//        print("tapped")
//        guard let SecondSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondSignUpVC") as? SecondSignUpViewController else { return }
//
//        SecondSignUpVC.modalTransitionStyle = .coverVertical
//        SecondSignUpVC.modalPresentationStyle = .fullScreen
//
//        self.present(SecondSignUpVC, animated: true, completion: nil)
                
        // 화면전환
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let SecondSignUpVC = UIStoryboard(name: "Signin", bundle: nil).instantiateViewController(withIdentifier: "SecondSignUpVC") as! SecondSignUpViewController
        SecondSignUpVC.artistackId = self.idTextField.text ?? ""
        
        self.present(SecondSignUpVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(SecondSignUpVC, animated: true)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        // 한 글자 입력할 때마다 실행
        
                // nicknameTextField
                if let text = idTextField.text {
                    
                    // 유효성 검사
                    let isValidID = text.range(of: "^[a-z0-9_]{0,}$", options: .regularExpression) != nil
                    
//                    if text.count >= 14 {
//                        // 14글자 넘어가면 자동으로 키보드 내려감
//                        textField.resignFirstResponder()
//                    }
                    
                    if text.count >= 4 && text.count <= 17 && isValidID {
                        warningTextLabel.text = "영문 소문자, 숫자, 밑줄기호 입력 가능 (총 4-17자)"
                        warningTextLabel.textColor = UIColor.init(named: "warning_text_grey")
                        nextButton.setImage(nextButtonAbled, for: .normal)
                        
                        nextButton.isEnabled = true
                        
                        // 아이디 중복 확인
                        let url = "https://dev.artistack.shop/users/duplicate" + "?type=artistackId&value=\(idTextField.text!)"
                        
                        AF.request(url,
                                   parameters: nil,
                                   encoding: URLEncoding.default).validate().responseDecodable(of: IdDuplicateModel.self) {
                            response in
                            switch response.result {
                            case .success(let result):
                                print("아이디 중복 검사 성공")
                                debugPrint(response)
                                if response.value!.data {
                                    print("중복된 아이디가 존재합니다")
                                    self.warningTextLabel.text = "중복된 닉네임입니다."
                                    self.warningTextLabel.textColor = .red
                                    self.nextButton.setImage(self.nextButtonDisabled, for: .normal)

                                    self.nextButton.isEnabled = false
                                    
                                }
                                else {
                                    print("중복된 아이디가 없습니다")
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                    else {
                        warningTextLabel.text = "영문 소문자, 숫자, 밑줄기호 입력 가능 (총 4-17자)"
                        warningTextLabel.textColor = .red
                        nextButton.setImage(nextButtonDisabled, for: .normal)

                        nextButton.isEnabled = false
                    }
                    // 초과되는 텍스트 제거
    //                    if text.count >= 14
    //                        let index = text.indôx(text.startIndex, offsetBy: 14)
    //                        let newString = text[text.startIndex..<index]
    //                        textField.text = String(newString)
    //                    }
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
                                               object: idTextField)
        
        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
        toolBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 54 / 844)
        nextButton = UIButton.init(type: .custom)
        nextButton.setImage(nextButtonDisabled, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        
//        nextButton.sizeToFit()
        nextButton.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 54 / 844)
        toolBar.barTintColor = .clear
        
//        nextButton.leftAnchor.constraint(equalTo: view.keyboardLayoutGuide.leftAnchor, constant: 0).isActive = true
//        nextButton.rightAnchor.constraint(equalTo: view.keyboardLayoutGuide.rightAnchor, constant: 0).isActive = true
        
         nextBarButton = UIBarButtonItem.init(customView: nextButton)
        toolBar.items = [nextBarButton]
        nextBarButton.isEnabled = false
        
//        toolBar.backgroundColor = UIColor.init(named: "screen_navy")
        idTextField.inputAccessoryView = toolBar
        

        // NSMutableAttributedString 타입으로 바꾼 text 저장
        let expStr = NSMutableAttributedString(string: expTextLabel.text!)
        
        // expTextLabel 부분 색상 설정
        expStr.addAttribute(.foregroundColor, value: UIColor.init(named: "final_darkgrey") as Any, range: (expTextLabel.text! as NSString).range(of: "스태커님만의 고유한 아이디를 만들어주세요."))
        
        // expTextLabel 행간 설정
        let expParagraphStyle = NSMutableParagraphStyle()
        expParagraphStyle.lineSpacing = 6
        expStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: expParagraphStyle, range: NSMakeRange(0, expStr.length))
        expTextLabel.attributedText = expStr

        // 설정이 적용된 text를 label의 attributedText에 저장
        expTextLabel.attributedText = expStr
        
        // headTextLabel 행간 설정
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
