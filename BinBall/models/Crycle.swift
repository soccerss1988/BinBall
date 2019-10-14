//
//  Circle.swift
//  BinBall
//
//  Created by YJ Huang on 2019/9/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

class Crycle: UIView {
    @IBOutlet weak var numberLab:UILabel!
    var theNumber = 0
    let strokeColor = UIColor.clear.cgColor
    let fillColor = UIColor(rgb: UROBILIN).withAlphaComponent(0.9).cgColor
    var lineWidth: CGFloat = 1
    lazy var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        _shapeLayer.strokeColor = self.strokeColor
        _shapeLayer.fillColor = self.fillColor
        return _shapeLayer
    }()
    
    static func instance(owner:Any) -> Crycle {
        return Bundle.main.loadNibNamed("Crycle", owner: owner, options: nil)?.last as! Crycle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = lineWidth
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = circularPath(lineWidth: lineWidth, center: center).cgPath
        
        self.numberLab.adjustsFontSizeToFitWidth = true
        self.bringSubviewToFront(self.numberLab)
    }
    
    private func circularPath(lineWidth: CGFloat = 0, center: CGPoint = .zero) -> UIBezierPath {
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .path }
    override var collisionBoundingPath: UIBezierPath { return circularPath() }
}
