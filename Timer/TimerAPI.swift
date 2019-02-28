//
//  TimerAPI.swift
//  Timer
//
//  Created by Zeqiang on 2019/2/26.
//  Copyright © 2019 Zeqiang. All rights reserved.
//

import Foundation

protocol TimerAPIDelegate {
    func tickHandler(timePast: Int)
    func resetHandler()
}

class TimerAPI {
 
    // MARK: Properties
    
    static let shared = TimerAPI()
    
    public var delegate : TimerAPIDelegate?
    
    private var countTimer : Timer!
    
    private var timePast : Int = 0
    
    private var countList = [Int]()
    
    // MARK: Methods
    
    public func start() {
        if countTimer == nil {
            countTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.timePast += 1
                self.delegate?.tickHandler(timePast: self.timePast)
            })
            
            RunLoop.current.add(countTimer, forMode: RunLoop.Mode.common)
            countTimer.fire()
        } else {
            countTimer.fireDate = Date.distantPast
        }
    }
    
    public func stop() {
        if countTimer != nil {
            countTimer.fireDate = Date.distantFuture
        }
    }
    
    public func count() {
        countList.append(timePast)
        print(timePast.toFormatedTimeString())
    }
    
    public func reset() {
        if countTimer != nil {
            countTimer.invalidate()
            countTimer = nil
            timePast = 0
            countList = [Int]()
            delegate?.resetHandler()
        }
    }
}

