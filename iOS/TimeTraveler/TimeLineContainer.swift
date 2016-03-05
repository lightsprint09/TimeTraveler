//
//  TimeLineContainer.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

protocol Displayable {
    var name: String { get }
}


protocol DurationPoint: class, Displayable {
    var duration: NSTimeInterval { get }
    var subtitle: String? { get }
    func asyncResolve(onSucess: (NSTimeInterval)->(), onError:(JSONFetcherErrorType)->())
    
    var tabelCellID: String { get }
    var image: UIImage { get }
}



protocol TargetTimeType: Displayable {
    var date: NSDate { get }
}

struct TargetTime: TargetTimeType {
    let date: NSDate
    let name: String
}

protocol ResultTimeType: Displayable {
    var date: NSDate { get }
}

struct ResultTime: ResultTimeType {
    let name: String
    let date: NSDate
}

class TimelineContainer {
    let targetTime: TargetTime
    var durationPoints = Array<DurationPoint>()
    
    init(targetTime: TargetTime) {
        self.targetTime = targetTime
    }
    
    private var timeDifference: NSTimeInterval {
        return -1 * durationPoints.reduce(0, combine: {current, next in
            return current + next.duration
        })
    }
    
    var currentResultTime: ResultTimeType {
       return ResultTime(name: "Zuhause", date: targetTime.date.dateByAddingTimeInterval(timeDifference))
    }
    
    func asynResolve(onSucess: (ResultTimeType)->(), onError:(JSONFetcherErrorType)->()) {
        let async = AsyncManager<NSTimeInterval, JSONFetcherErrorType>(count: durationPoints.count, didFinishCallback: {_, _ in
            onSucess(self.currentResultTime)
        })
        for (_, durationPoint) in durationPoints.enumerate() {
            durationPoint.asyncResolve(async.addResult, onError: async.addError)
        }
    }
}
