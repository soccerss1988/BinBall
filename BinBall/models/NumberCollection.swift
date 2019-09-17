//
//  BallCollection.swift
//  BinBall
//
//  Created by YJ Huang on 2019/9/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

class NumberCollection: NSObject {
     var originCollection = [Int]()
    
    init(counts:Int) {
        for number in 1...counts {
            self.originCollection.append(number)
        }
    }
    
    func getNunber() -> Int {
        let index = Int(arc4random()) % self.originCollection.count
        let number = self.originCollection[index]
        self.originCollection.remove(at: index)
        return number
    }
}
