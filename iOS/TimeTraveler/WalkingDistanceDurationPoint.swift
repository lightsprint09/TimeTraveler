//
//  WalkingDistanceDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import UIKit

class WalkingDistanceDurationPoint: DurationPoint {
    var duration: NSTimeInterval = 0
    let name: String
    var subtitle: String?
    var passed = false
    
    let tabelCellID = "standardtcell"
    var targetDate: NSDate!
    
    var image = UIImage(named: "Bullet Point")!
    var walking: Walking?
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        let urlString = "https://time-traveler-api.herokuapp.com/distance?start=\(origin)&end=\(destination)".stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let url = NSURL(string: urlString!)
        func sucess(result: Walking) {
            duration = NSTimeInterval(60 * result.duration) * TravelSpeed.multiplier 
            self.walking = result
            dispatch_async(dispatch_get_main_queue(), {
                onSucess(result.time)
            })
            
        }
        
        JSONFetcher().loadObject(url!, onSucess: sucess, onError: onError)
    
    }
    
    private let origin: String
    private let destination: String
    
    init(origin: String, destination: String) {
        self.origin = origin
        self.destination = destination
        self.name = "Fußweg: \(origin) ➜ \(destination)"
    }
}

extension Walking: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.distance = JSON["distance"] as! Int
        self.duration = JSON["transitTime"] as! Int
    }
}

struct Walking {
    let distance: Int
    let duration: Int // minutes
    
    var time: NSTimeInterval {
        return NSTimeInterval(duration * 60)
    }
}
