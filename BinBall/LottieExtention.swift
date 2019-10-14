//
//  LottieExtention.swift
//  BinBall
//
//  Created by YJ Huang on 2019/10/13.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import Foundation
import UIKit
import Lottie
extension UIView {
    
    func getLottieAnimation(_ name: String, loopMode: LottieLoopMode) ->AnimationView {
        let animation = Animation.named(name)
        let animationView =  AnimationView(animation: animation)
        animationView.loopMode = loopMode
        return animationView
    }
    
    
}
