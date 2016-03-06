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
    func fetchFlightInformation(flightReference: FlightReference, onSucces: (FlightStatus)->(), onErrror: (JSONFetcherErrorType)->()) {
        let url = NSURL(string: "https://time-traveler-api.herokuapp.com/flightInfo/\(flightReference.boockingReferenceID)")
        func sucess(result: FlightStatusSegment) {
            let flightStatus = FlightStatus(segments: [result])
            dispatch_async(dispatch_get_main_queue(),{
                onSucces(flightStatus)
            })

        }
        
        jsonFetcher.loadObject(url!, onSucess: sucess, onError: onErrror)
    }
    
    func fetchFlightStatus(status: FlightStatus, onSucces: (FlightStatusInfo)->(), onErrror: (JSONFetcherErrorType)->()) {
        let url = NSURL(string: "https://time-traveler-api.herokuapp.com/flightStatus?airline_code=LH&flight_number=\(status.segments.first!.marketingCarrier.flightNumber)&departure_date=2016-03-05")
        func sucess(result: FlightStatusInfo) {
            
            dispatch_async(dispatch_get_main_queue(),{
                onSucces(result)
            })
            
        }
        
        jsonFetcher.loadObject(url!, JSONKeyPath: "Departure", onSucess: sucess, onError: onErrror)
        
    }
}

extension FlightStatusInfo: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let terminalData = JSON["Terminal"] as! Dictionary<String, AnyObject>
        self.terminal = "\(terminalData["Name"] as! Int)"
        self.gate = terminalData["Gate"] as! String
        self.status = (JSON["TimeStatus"] as! Dictionary<String, AnyObject>)["Code"] as! String
    }
}

extension FlightStatusSegment: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.segmentKey = JSON["SegmentKey"] as! String
        self.arrival = TimePoint(JSON: JSON["Arrival"] as! Dictionary<String, AnyObject>)
        self.depature =  TimePoint(JSON: JSON["Departure"] as! Dictionary<String, AnyObject>)
        self.marketingCarrier = MarketingCarrier(JSON: JSON["MarketingCarrier"] as! Dictionary<String, AnyObject>)
        self.seatItem = SeatItem(JSON: JSON["SeatItem"] as! Dictionary<String, AnyObject>)
    }
}

extension TimePoint: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let dateTimeString =  "\(JSON["Date"] as! String)\(JSON["Time"] as! String)"
        self.date = FlightStatusService.datetimeFormatter.dateFromString(dateTimeString)!
        self.airportCode = JSON["AirportCode"] as! String
    }
}

extension SeatItem: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {        
        self.seatColumn =  (JSON["Location"] as! Dictionary<String, AnyObject>)["Column"] as! String
        self.seatRow = (JSON["Location"] as! Dictionary<String, AnyObject>)["Row"]!["Number"] as! Int
        
       
    }
}
extension MarketingCarrier: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.airlineID = JSON["AirlineID"] as! String
        self.flightNumber = "\(JSON["FlightNumber"] as! Int)"
    }
}

