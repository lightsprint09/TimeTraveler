//
//  FakeDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

class FakeDurationPoint: DurationPoint {
    var duration: NSTimeInterval
    let name: String
    var subtitle: String?
    var targetDate: NSDate!
    var passed = false
    
    let tabelCellID = "standardtcell"
    
    var image = UIImage(named: "Bullet Point")!
    
    init(name: String, duration: NSTimeInterval) {
        self.name = name
        self.duration = duration
    }
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        onSucess(duration)
    }
}