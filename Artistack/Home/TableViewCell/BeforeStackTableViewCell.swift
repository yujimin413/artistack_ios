//
//  BeforeStackTableViewCell.swift
//  Practice_Artistack
//
//  Created by 임영준 on 2022/07/30.
//

import UIKit

class BeforeStackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.addDiamondMask()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideLine(){
        line.isHidden = true
    }
    
}
