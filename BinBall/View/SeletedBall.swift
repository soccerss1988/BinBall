//
//  SeletedBall.swift
//  BinBall
//
//  Created by YJ Huang on 2019/10/4.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

class SeletedBall: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var numberLab: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.animate(withDuration: 0.7) {
            self.bgView.alpha = 1
            self.bgView.backgroundColor = UIColor(rgb: UROBILIN)
        }
    }
}
