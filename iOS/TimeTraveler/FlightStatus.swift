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
    
    private static var dateFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "dd MMM yyyy"
        
        return dateParser
    }()
    
    private static var timeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "HH:mm"
        
        return dateParser
    }()
    
    var dateString: String {
        return TimePoint.dateFormatter.stringFromDate(date)
    }
    
    var timeString: String {
        return TimePoint.timeFormatter.stringFromDate(date)
    }
}

struct FlightStatusSegment {
    let segmentKey: String
    let arrival: TimePoint
    let depature: TimePoint
    let marketingCarrier: MarketingCarrier
    let seatItem: SeatItem
    
}

struct FlightStatusInfo {
    let terminal: String
    let gate: String
    let status: String
}

struct MarketingCarrier {
    let airlineID: String
    let flightNumber: String
    
    var flight: String {
        return airlineID + flightNumber
    }
}

struct SeatItem {
    let seatRow: Int
    let seatColumn: String
    
    var seatNumber: String{
        return seatColumn + String(seatRow)
    }
}