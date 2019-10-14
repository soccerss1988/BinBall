//
//  ViewController.swift
//  BinBall
//
//  Created by YJ Huang on 2019/9/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
import ImageIO
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ballContainView: UIView!
    @IBOutlet weak var rewardView: UIView!
    
    //MARK:- UIdynamic property
    var animator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var bevar : UIDynamicItemBehavior!
    var instantaneousPush : UIPushBehavior!
    var circleLayer : CAShapeLayer?
    var balls = [Crycle]()
    var initNumber = 1
    var timer : Timer?
    var selectedBalls = [Crycle]()
    
    
    //MARK: -lottie
    lazy var winnerLottieView : AnimationView = {
        return self.view.getLottieAnimation("balloons", loopMode: .loop)
    }()
    lazy var giftLottieView : AnimationView = {
        return self.view.getLottieAnimation("balloons", loopMode: .loop)
    }()
    
    lazy var rewardLottieView : AnimationView = {
        return self.view.getLottieAnimation("reward", loopMode: .loop)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.mainViewStyle()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initDiynamic(balls: self.balls)
        self.animator.addBehavior(self.collision)
        self.testLottie()
    }
    
    func mainViewStyle() {
        self.collectionView.backgroundColor = UIColor(rgb:SWEET_BROWN)
        self.ballContainView.backgroundColor = UIColor(rgb: OUTER_SPACE)
    }
    
    func darwCircle(In:UIView,center:CGPoint,radius:CGFloat) {
        let circlePath = self.darwCircleBezierPath(center: center, radius: radius)
        self.circleLayer = self.circleLayer(path: circlePath, storkeColor:UIColor(rgb: OUTER_SPACE))
        In.layer.addSublayer(self.circleLayer!)
        self.collision.addBoundary(withIdentifier: "circle" as NSCopying, for: circlePath)
    }
    
    func darwCircleBezierPath(center:CGPoint,radius:CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter:center , radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
    }
    
    func circleLayer(path:UIBezierPath, storkeColor:UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 2; // Add it here
        layer.path = path.cgPath;
        layer.strokeColor = storkeColor.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        return layer
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
        
        // darwCircle
        self.darwCircle(In: self.view, center: self.ballContainView.center, radius: self.ballContainView.frame.size.width/2)
    }
    
    func updateDiynamic(newBall:Crycle) {
        //碰撞
        self.collision.addItem(newBall)
        //彈性
        self.bevar.addItem(newBall)
        //gra
        self.gravity.addItem(newBall)
    }
    
    override func viewDidLayoutSubviews() {
        self.ballContainView.layer.cornerRadius = self.ballContainView.frame.size.width/2
        self.ballContainView.layer.masksToBounds = true
        
        var size : CGFloat = 250
        self.giftLottieView.frame = CGRect(x: self.ballContainView.frame.minX - size/5, y: self.ballContainView.frame.maxY - size, width: size, height: size)

        size = 300
        self.winnerLottieView.frame = CGRect(x: self.ballContainView.frame.maxX - size/2, y: self.ballContainView.frame.maxY - size, width: size, height: size)
        
        self.rewardLottieView.frame = self.rewardView.bounds
    }
    
    
    //MARK: - Button Action
    @IBAction func addAction(_ sender: Any) {
        for _ in 1...46 {
            self.addNewBall(number: initNumber, radius: self.view.screenSize().width*0.035)
            initNumber += 1
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(moving(_:)), userInfo: nil, repeats: false)
    }
    
    func addNewBall(number: Int, radius:CGFloat) {
        let newball = Crycle.instance(owner: self)
        newball.frame = CGRect(x:self.view.center.x , y: self.view.center.y - 30, width: radius, height: radius)
        newball.numberLab.text = String(number)
        newball.theNumber = number
        self.view.addSubview(newball)
        self.balls.append(newball)
        self.updateDiynamic(newBall: newball)
    }
    
   @objc @IBAction func moving(_ sender: Any) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(InstantPush), userInfo: nil, repeats: true)
    }
    
    //順間推力
    @objc func InstantPush() {
        var bb = [Crycle]()
        for _ in 0 ..< self.balls.count/7 {
            let getball = Int(arc4random()) % Int(self.balls.count)
            bb.append(self.balls[getball])
        }
    
        self.instantaneousPush = UIPushBehavior(items: bb, mode: UIPushBehavior.Mode.instantaneous)
        var acr = Int(arc4random()) % Int(Double.pi * 2)
        
        
        let direction = Int(arc4random() % 1)
        if direction == 0 {
            acr = -acr
        }
        self.instantaneousPush?.setAngle(CGFloat(acr), magnitude: 4)
        self.animator.addBehavior(self.instantaneousPush)
    }
    
    @IBAction func selectAction(_ sender: Any) {
        let totoalCount = self.balls.count
        if totoalCount > 0 {
            let selectedIndex = Int(arc4random()) % totoalCount
            let selectBall = self.balls[selectedIndex]
            self.balls.remove(at: selectedIndex)
            self.removeCollision(ball: selectBall)
            if self.balls.count == 0 {
                initNumber = 1
                self.clearAction(self)
            }
            
            self.rewardLottieView.loopMode = .playOnce
            self.rewardLottieView.animationSpeed = 3
            self.rewardLottieView.play()
            //add selection ball in collecion view
            self.selectedBalls.append(selectBall)
            //reload collecion
            self.collectionView.reloadData()
            
            //with animaiotn
            let lastItemIndex = NSIndexPath(item:self.selectedBalls.count - 1 , section: 0)
            self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .bottom, animated: true)
            
            
        }
    }
    
    @IBAction func clearAction(_ sender: Any) {
        for subview in self.view.subviews {
            if subview is Crycle {
                self.removeCollision(ball: subview as! Crycle)
                 self.instantaneousPush.removeItem(subview as! Crycle)
            }
        }
        
        //reset init number
        initNumber = 1
        
        //stop movie
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        //remvoe
        self.balls.removeAll()
        self.selectedBalls.removeAll()
        self.collectionView.reloadData()
    }
    
    func removeCollision(ball:Crycle) {
        ball.removeFromSuperview()
        self.collision.removeItem(ball)
    }
    
    func testLottie() {
        self.view.addSubview(self.winnerLottieView)
//        self.view.bringSubviewToFront(self.winnerLottieView)
        self.view.addSubview(self.giftLottieView)
//        self.view.bringSubviewToFront(self.giftLottieView)
        self.rewardView.addSubview(self.rewardLottieView)
        
        self.giftLottieView.play(fromFrame: 1, toFrame: 20, loopMode: .playOnce, completion: nil)
        self.winnerLottieView.play(fromFrame: 20, toFrame: 30, loopMode: .playOnce, completion: nil)
        
        self.rewardLottieView.loopMode = .playOnce
        self.rewardLottieView.animationSpeed = 3
        self.rewardLottieView.play()
        
    }
}

//MARK: UIcollectionview delegate
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedBalls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "selectedBallCell", for: indexPath) as! SeletedBall
        let theball = self.selectedBalls[indexPath.row]
        cell.numberLab.text = theball.numberLab.text!
        return cell
    }
    
}

extension UIView {
    func screenSize() -> CGRect {
        return UIScreen.main.bounds
    }
}
