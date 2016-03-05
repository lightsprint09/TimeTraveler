//
//  WalkingDistanceDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

class WalkingDistanceDurationPoint: DurationPoint {
    var duration: NSTimeInterval = 0
    let name: String
    var subtitle: String?
    
    let tabelCellID = "standardtcell"
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        let urlString = "https://timetraveler-server.herokuapp.com/distance?start=\(origin) A&end=\(destination)".stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
        let url = NSURL(string: urlString!)
        func sucess(result: Walking) {
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
        self.name = "Fußweg von \(origin) nach \(destination)"
    }
    
    static var transportToTerminal1: WalkingDistanceDurationPoint {
        return WalkingDistanceDurationPoint(origin: "Regional Bahnhof", destination: "The Squaire")
    }
}

extension Walking: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.distance = JSON["distance"] as! Int
        self.duration = JSON["duration"] as! Int
    }
}

struct Walking {
    let distance: Int
    let duration: Int // minutes
    
    var time: NSTimeInterval {
        return NSTimeInterval(duration * 60)
    }
}
