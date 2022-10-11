//
//  StackerCollectionViewCell.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/01.
//

import UIKit

class StackerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stackerImageView: UIImageView!
    
    @IBOutlet weak var stackerInstrImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.stackerImageView.addDiamondMask()
        // Initialization code
    }

    
    
}
