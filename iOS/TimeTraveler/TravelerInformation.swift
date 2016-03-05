//
//  FlightInformation.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

enum LaguageType {
    case Handbag
    case BigBag(Int?)
    case Both
}

enum TravelSpeed: Int {
    case Slow = 0
    case Medium = 1
    case Fast = 2
}

enum TransportType {
    case PlublicTransport
    case Car
}

struct FlightReference {
    let boockingReferenceID: String
    var isValid = false
}

class TravelerInformation {
    //User Input
    var flightReference: FlightReference?
    var laguageType: LaguageType?
    var transportType: TransportType?
    var travelSpeed: TravelSpeed?
    
    
    //fetched Data
    var flightStatus: FlightStatus? {
        didSet {
            flightReference?.isValid = true
        }
    }
    
    var targetTime: TargetTime {
        return TargetTime(date: (flightStatus?.from?.date)!, name: "Abflugzeit")
    }
}
