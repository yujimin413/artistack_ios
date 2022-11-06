//
//  CollectionReusableView.swift
//  Artistack
//
//  Created by 유지민 on 2022/07/25.
//

import UIKit

class CollectionReusableView: UICollectionViewCell {
    
    @IBOutlet weak var myProjectCount: UILabel!
    static let identifier = "CollectionReusableView"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCount(data: Int){
        print("hihi")
    }
    
    // 내 연주 수
    func setupData(_ myProjectCount: Int?) {
        guard let myProjectCount = myProjectCount else { return }
        self.myProjectCount.text = "\(myProjectCount)"

    }
}
