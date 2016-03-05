//
//  FlightStatusService.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct FlightStatusService {
    private static var dateFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd"
        
        return dateParser
    }()
    
    static var timeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "HH:mm"
        
        return dateParser
    }()
    
    static var datetimeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "yyyy-MM-ddHH:mm"
        
        return dateParser
    }()
    
    let jsonFetcher = JSONFetcher()
    func fetchFlightStatus(flightReference: FlightReference, onSucces: (FlightStatus)->(), onErrror: (JSONFetcherErrorType)->()) {
        let url = NSURL(string: "https://timetraveler-server.herokuapp.com/flightInfo/\(flightReference.boockingReferenceID)")
        func sucess(result: FlightStatusSegment) {
            let flightStatus = FlightStatus(segments: [result])
            dispatch_async(dispatch_get_main_queue(),{
                onSucces(flightStatus)
            })

        }
        
        jsonFetcher.loadObject(url!, onSucess: sucess, onError: onErrror)
    }
}

extension FlightStatusSegment: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.segmentKey = JSON["SegmentKey"] as! String
        self.arrival = TimePoint(JSON: JSON["Arrival"] as! Dictionary<String, AnyObject>)
        self.depature =  TimePoint(JSON: JSON["Departure"] as! Dictionary<String, AnyObject>)
        self.marketingCarrier = MarketingCarrier(JSON: JSON["MarketingCarrier"] as! Dictionary<String, AnyObject>)
    }
}

extension TimePoint: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let dateTimeString =  "\(JSON["Date"] as! String)\(JSON["Time"] as! String)"
        self.date = FlightStatusService.datetimeFormatter.dateFromString(dateTimeString)!
        self.airportCode = JSON["AirportCode"] as! String
    }
}

extension MarketingCarrier: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.airlineID = JSON["AirlineID"] as! String
        self.flightNumber = JSON["FlightNumber"] as? String ?? ""
    }
}

