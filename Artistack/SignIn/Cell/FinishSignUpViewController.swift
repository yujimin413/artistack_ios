//
//  FinishSignUpViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/08/08.
//

import UIKit

class FinishSignUpViewController: UIViewController {
    @IBOutlet weak var artistackerLabel: UILabel!
    
    // 닉네임 받아오기
    var nickname : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttribute()
        
        
    }
    @IBAction func nextButtonDidTap(_ sender: Any) {
        let TabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(TabBarController, animated: true, completion: nil)
    }
    
    func setupAttribute() {
        
        // '아티스태커' -> '닉네임' 텍스트 수정
        let strWithChangedNickname = artistackerLabel.text?.replacingOccurrences(of: "아티스태커", with: nickname)
        
        // NSMutableAttributedString 타입으로 바꾼 text 저장
        let artistackerStr = NSMutableAttributedString(string: strWithChangedNickname!)

        // 부분 색상 설정
//        artistackerStr.addAttribute(.foregroundColor, value: UIColor.white, range: (artistackerLabel.text! as NSString).range(of: "아티스태커"))

        // 설정이 적용된 text를 label의 attributedText에 저장
        artistackerLabel.attributedText = artistackerStr
        
        // headTextLabel 행간 설정
        let artistackerParagraphStyle = NSMutableParagraphStyle()
        artistackerParagraphStyle.lineSpacing = 6
        artistackerStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: artistackerParagraphStyle, range: NSMakeRange(0, artistackerStr.length))
        artistackerLabel.attributedText = artistackerStr
    }
}

// 커스텀 컬러
//extension UIColor {
//    class var final_lightgrey: UIColor? { return UIColor(named: "final_lightgrey") }
//}
