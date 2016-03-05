//
//  RMVService.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import MapKit

struct RMVService {
    private static var dateFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd"
        dateParser.timeZone = NSTimeZone.systemTimeZone()
        
        return dateParser
    }()
    
    private static var timeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "HH:mm:ss"
        dateParser.timeZone = NSTimeZone.systemTimeZone()
        
        return dateParser
    }()
    
    static var datetimeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "yyyy-MM-ddHH:mm:ss"
        dateParser.timeZone = NSTimeZone.systemTimeZone()
        
        return dateParser
    }()
    
    let jsonFetcher = JSONFetcher()
    func fetchRMVTrip(location: Location, onSucces: (RMVRoute)->(), onErrror: (JSONFetcherErrorType)->()) {
        let url = NSURL(string: "https://timetraveler-server.herokuapp.com/tripToAirport?originCoordLat=\(location.latitude)&originCoordLong=\(location.longitude)")
        func sucess(result: Array<RMVTrip>) {
            let route = RMVRoute(trips: result)
            dispatch_async(dispatch_get_main_queue(),{
                onSucces(route)
            })
            
        }
        
        jsonFetcher.loadList(url!, JSONKeyPath: "Trip", onSucess: sucess, onError: onErrror)
    }
}

extension RMVTrip: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        if let legsdata = (JSON["LegList"] as! NSDictionary)["Leg"] as? Array<Dictionary<String, AnyObject>> {
            self.legs = legsdata.map { data in
                return Leg(JSON: data)
            }
        }else {
            self.legs = []
        }
        
    }
}

extension Leg: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.destination = Station(JSON: JSON["Origin"] as! Dictionary<String, AnyObject>)
        self.origin = Station(JSON: JSON["Destination"] as! Dictionary<String, AnyObject>)
    }
}

extension Station: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        self.name = JSON["name"] as! String
        self.id = JSON["id"] as! String
        let longitude = JSON["lon"] as! Double
        let latitude = JSON["lat"] as! Double
        self.location = Location(latitude: latitude, longitude: longitude)
        let dateTimeString =  "\(JSON["date"] as! String)\(JSON["time"] as! String)"
        self.date = RMVService.datetimeFormatter.dateFromString(dateTimeString)!
    }
}
extension String {
    func removeLast(n: Int) -> String {
        var test = self
        for var i = 0; i < n; i++ {
            test = test.substringToIndex(test.endIndex.predecessor())
        }
        
        return test
    }
    
}