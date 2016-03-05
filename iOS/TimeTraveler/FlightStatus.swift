//
//  FlightStatus.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct FlightStatus {
    let segments: Array<FlightStatusSegment>
    var from: TimePoint? {
        return segments.first?.depature
    }
    
    var to: TimePoint? {
        return segments.last?.arrival
    }
    
}

struct TimePoint {
    let airportCode: String
    let date: NSDate
}

struct FlightStatusSegment {
    let segmentKey: String
    let arrival: TimePoint
    let depature: TimePoint
    let marketingCarrier: MarketingCarrier
}

struct MarketingCarrier {
    let airlineID: String
    let flightNumber: String
    
    var flight: String {
        return airlineID + flightNumber
    }
}