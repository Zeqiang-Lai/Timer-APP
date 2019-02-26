//
//  Int+.swift
//  Timer
//
//  Created by Zeqiang on 2019/2/26.
//  Copyright © 2019 Zeqiang. All rights reserved.
//

import Foundation

extension Int {
    func toFormatedTimeString() -> String{
        let milSec = self % 100
        let sec = (self / 100) % 60
        let min = (self / 6000) % 60
        
        let formatString = String(format: "%02d:%02d.%02d", min, sec, milSec)
       
        return formatString
    }
}
