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
    
    var timeLineContainer: TimelineContainer!
    
    
    //fetched Data
    var flightStatus: FlightStatus? {
        didSet {
            flightReference?.isValid = true
            timeLineContainer = TimelineContainer(targetTime: targetTime)
            let fakeWalkSecToGate: DurationPoint = FakeDurationPoint(name: "Weg zum Gate", duration: 12 * 60)
            let fakeSecuritySec = FakeDurationPoint(name: "Security", duration: 28 * 60)
            let fakeSecurityToSec = FakeDurationPoint(name: "Weg zur Security", duration: 8 * 60)
            let fakeSecurityBackageDrop = FakeDurationPoint(name: "Kofferabgabe", duration: 15 * 60)
            let fakeSecurityToBackage = FakeDurationPoint(name: "Weg zur Kofferabgabe", duration: 20 * 60)
            timeLineContainer.durationPoints.appendContentsOf([fakeWalkSecToGate, fakeSecuritySec, fakeSecurityToSec, fakeSecurityToSec,fakeSecurityBackageDrop, fakeSecurityToBackage])
        }
    }
    
    var targetTime: TargetTime {
        return TargetTime(date: (flightStatus?.from?.date)!, name: "Abflugzeit")
    }
}
