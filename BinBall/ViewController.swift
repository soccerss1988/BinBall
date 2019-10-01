//
//  ViewController.swift
//  BinBall
//
//  Created by YJ Huang on 2019/9/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var bevar :UIDynamicItemBehavior!
    var balls = [Crycle]()
    var path = UIBezierPath(ovalIn: CGRect(x: 10, y: 600, width: 200, height: 100))
    var initNumber = 1
    lazy var Circle : UIBezierPath = {
        let center = CGPoint(x: self.view.center.x - 20, y: self.view.center.y - 20)
        return UIBezierPath(arcCenter:center , radius: self.view.frame.height/2.7, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
    }()
    var instantaneousPush : UIPushBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDiynamic(balls: self.balls)
        
    }
    
    func addLine() {
        self.path.lineWidth = 5
        self.collision.addBoundary(withIdentifier: "circle" as NSCopying, for: self.Circle)
        UIGraphicsBeginImageContext(self.view.bounds.size);
        
        let layer = CAShapeLayer()
        layer.lineWidth = 4; // Add it here
        layer.path = self.Circle.cgPath;
        layer.strokeColor = UIColor.red.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        self.view.layer.addSublayer(layer)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        for subview in self.view.subviews {
            if subview is Crycle {
                self.removeCollision(ball: subview as! Crycle)
            }
        }
        initNumber = 1
    }
    @IBAction func addAction(_ sender: Any) {
        
        let newball = Crycle.instance(owner: self)
        newball.frame = CGRect(x:self.view.center.x , y: self.view.center.y - 30, width: 60, height: 60)
        newball.Number.text = String(initNumber)
        self.view.addSubview(newball)
        
        self.balls.append(newball)
        self.updateDiynamic(newBall: newball)
        initNumber += 1
    }
    
    func initDiynamic(balls:[Crycle]) {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        //碰撞
        self.collision = UICollisionBehavior(items: balls)
        self.collision.translatesReferenceBoundsIntoBoundary = true;
        self.animator.addBehavior(self.collision)
        
        //彈性
        self.bevar = UIDynamicItemBehavior(items: balls)
        self.bevar.elasticity = 0.9
        self.animator.addBehavior(self.bevar)
        
        //gra
        self.gravity = UIGravityBehavior(items: balls)
        self.animator.addBehavior(self.gravity)
        
        self.addLine()
    }
    
    //順間推力
    @objc func InstantPush() {
//        self.continuousPush = UIPushBehavior(items:[self.dynamicView], mode: UIPushBehaviorMode.Continuous)
        
        var bb = [Crycle]()
        for _ in 0 ..< self.balls.count/2 {
            let getball = Int(arc4random()) % Int(self.balls.count)
            bb.append(self.balls[getball])
        }
    
        
        self.instantaneousPush = UIPushBehavior(items: bb, mode: UIPushBehavior.Mode.instantaneous)
//        self.continuousPush?.setAngle(CGFloat(M_PI_2), magnitude: 0.2)
        let acr = Int(arc4random()) % Int(Double.pi)
        self.instantaneousPush?.setAngle(-CGFloat(acr), magnitude: 4)
//        self.animator.addBehavior(self.continuousPush)
        self.animator.addBehavior(self.instantaneousPush)
    }
    
    
    func updateDiynamic(newBall:Crycle) {
        //碰撞
        self.collision.addItem(newBall)
        //彈性
        self.bevar.addItem(newBall)
        //gra
        self.gravity.addItem(newBall)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.animator.addBehavior(self.collision)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func moving(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(InstantPush), userInfo: nil, repeats: true)
    }
    
    @IBAction func selectAction(_ sender: Any) {
        let totoalCount = self.balls.count
        let selectedIndex = Int(arc4random()) % totoalCount
        let selectBall = self.balls[selectedIndex]
        print(selectBall.Number.text!)
        self.balls.remove(at: selectedIndex)
        self.removeCollision(ball: selectBall)
        if self.balls.count == 0 {
            initNumber = 1
            self.clearAction(self)
        }
    }
    
    func removeCollision(ball:Crycle) {
        ball.removeFromSuperview()
        self.collision.removeItem(ball)
    }
}


