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
    var flightStatusInfo: FlightStatusInfo?
    var flightNumber: String?
    var arrivalAirport: String?
    var arrivalTime: String?
    var departureTime: String?
    var departureAirport: String?
    var flightDate: String?
    var seatNumber: String?
    
    var timeLineContainer: TimelineContainer!
    
    
    //fetched Data
    var flightStatus: FlightStatus? {
        didSet {
            flightReference?.isValid = true
            flightNumber =  (flightStatus?.segments.first!.marketingCarrier.airlineID)! + (flightStatus?.segments.first!.marketingCarrier.flightNumber)!
            departureAirport = flightStatus?.from?.airportCode
            departureTime = flightStatus?.from?.timeString
            flightDate = flightStatus?.from?.dateString
            arrivalAirport = flightStatus?.to?.airportCode
            arrivalTime = flightStatus?.to?.timeString
            seatNumber = flightStatus?.segments.first!.seatItem.seatNumber
            
            timeLineContainer = TimelineContainer(targetTime: targetTime)
            let fakeWalkSecToGate: DurationPoint = FakeDurationPoint(name: "Weg zum Gate", duration: 12 * 60)
            let fakeSecuritySec = FakeDurationPoint(name: "Security", duration: 28 * 60)
            let fakeSecurityToSec = FakeDurationPoint(name: "Weg zur Security", duration: 8 * 60)
            let fakeSecurityBackageDrop = FakeDurationPoint(name: "Kofferabgabe", duration: 15 * 60)
            let fakeSecurityToBackage = FakeDurationPoint(name: "Weg zur Kofferabgabe", duration: 20 * 60)
            timeLineContainer.durationPoints.appendContentsOf([fakeWalkSecToGate, fakeSecuritySec, fakeSecurityToSec ,fakeSecurityBackageDrop, fakeSecurityToBackage])
        }
    }
    
    var targetTime: TargetTime {
        return TargetTime(date: (flightStatus?.from?.date)!, name: "Abflugzeit")
    }
}
