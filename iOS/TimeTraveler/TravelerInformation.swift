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
    case BigBag
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
        }
    }
    
    var targetTime: TargetTime {
        return TargetTime(date: (flightStatus?.from?.date)!, name: "Abflugzeit")
    }
}
