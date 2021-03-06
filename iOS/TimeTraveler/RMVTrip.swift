//
//  RMVTrip.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct RMVTrip {
    let legs: Array<Leg>
    
    var duration: NSTimeInterval? {
        guard let destinationDate = legs.last?.destination?.date, let originDate = legs.first?.origin?.date else { return nil }
        return destinationDate.timeIntervalSinceDate(originDate)
    }
}

struct RMVRoute {
    let trips: Array<RMVTrip>
    
    init(trips: Array<RMVTrip>) {
        self.trips = trips.filter({trip in
            return trip.legs.last?.destination?.name == "Frankfurt (Main) Flughafen Regionalbahnhof"
        })
    }
}

struct Station {
    let name: String
    let id: String
    let location: Location
    let date: NSDate
}

struct Leg {
    let destination: Station?
    let origin: Station?
}