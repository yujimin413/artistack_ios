//
//  LikeTableViewCell.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/03.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var likerImageView: UIImageView!
    @IBOutlet weak var likerNicknameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likerImageView.addDiamondMask()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
