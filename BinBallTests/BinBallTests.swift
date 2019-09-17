//
//  BinBallTests.swift
//  BinBallTests
//
//  Created by YJ Huang on 2019/9/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import XCTest
@testable import BinBall

class BinBallTests: XCTestCase {
    var ball = BallCollection(counts: 5)
    var numbers = NumberCollection(counts: 100)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBall() {
        for _ in 1...5 {
            if ball.originCollection.count == 0 {
                break
            } else {
                let nn = ball.getNunber()
                print(nn)
            }
        }
        XCTAssertEqual(0, ball.originCollection.count)
    }
    
    func testgetNumber() {
        for _ in stride(from: 0, to: numbers.originCollection.count, by: 1) {
        
            if numbers.originCollection.count == 0 {
                break
            } else {
                let nn = numbers.getNunber()
                print(nn)
                print("last \(numbers.originCollection)")
            }
        }
        XCTAssertEqual(0, numbers.originCollection.count)
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.testgetNumber()
        }
    }

}
