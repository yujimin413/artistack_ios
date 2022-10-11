//
//  InstCollectionViewCell.swift
//  Artistack
//
//  Created by 임영준 on 2022/07/24.
//

struct ImageInfo {
    let name: String
    let labelname: String
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init (name: String, labelname: String) {
        self.name = name
        self.labelname = labelname
    }
}

import UIKit

class InstCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var InstImageVIew: UIImageView!
    @IBOutlet weak var InstLabel: UILabel!
    
    func update(info: ImageInfo) {
          InstImageVIew.image = info.image
          InstLabel.text = info.labelname
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(named: "instFill")
                self.borderColor = UIColor(named: "ActiveColor")
                self.InstLabel.textColor = UIColor(named: "ActiveTextColor")
            } else {
                backgroundColor = .clear
                self.borderColor = UIColor(named: "lineColor")
                self.InstLabel.textColor = UIColor(named: "textColor")

            }
        }
    }
               
}

// view model
class InstImageViewModel {
    let imageInfoList: [ImageInfo] = [
        ImageInfo(name: "PianoImage", labelname: "피아노"),
        ImageInfo(name: "GuitarImage", labelname: "기타"),
        ImageInfo(name: "BassImage", labelname: "베이스"),
        ImageInfo(name: "DrumImage", labelname: "드럼"),
        ImageInfo(name: "VocalImage", labelname: "보컬"),
        ImageInfo(name: "EtcImage", labelname: "그 외 악기"),
    ]
    
    var countOfImageList: Int {
        return imageInfoList.count
    }
    
    func imageInfo(at index: Int) -> ImageInfo {
        return imageInfoList[index]
    }
    
}
