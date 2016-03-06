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
    
    var targetDate: NSDate! { get set }
    var passed: Bool { get set }

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
    let center = NSNotificationCenter.defaultCenter()
    
    var addedHeader:  Array<DurationPoint> {
        var durations = durationPoints
        let origin = HeaderFooterDuration(name: "Abktueller Ort - Abfahrt", image: UIImage(named: "Location")!)
        origin.targetDate = currentResultTime.date
        durations.append(origin)
        let boarding = HeaderFooterDuration(name: "Take Off", image: UIImage(named: "Flight")!)
        boarding.targetDate = targetTime.date
        durations.insert(boarding, atIndex: 0)
        
        return durations
    }
    
    init(targetTime: TargetTime) {
        self.targetTime = targetTime
        center.addObserver(self, selector: Selector("recieve"), name: "beacon", object: nil)
    }
    
    dynamic func recieve() {
        for (_, durationPoint) in durationPoints.enumerate() where durationPoint is LocalTrainDurationPoint {
            durationPoint.passed = true
        }
        center.postNotificationName("update", object: nil)
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
        update()
        let async = AsyncManager<NSTimeInterval, JSONFetcherErrorType>(count: durationPoints.count, didFinishCallback: {_, _ in
            self.update()
            onSucess(self.currentResultTime)
        })
        for (_, durationPoint) in durationPoints.enumerate() {
            durationPoint.asyncResolve(async.addResult, onError: async.addError)
        }
    }
    
    private func update() {
        var targetDate = targetTime.date
        for(_, duration) in durationPoints.enumerate() {
            targetDate = targetDate.dateByAddingTimeInterval(-1 * duration.duration)
            duration.targetDate = targetDate
        }
    }
}
