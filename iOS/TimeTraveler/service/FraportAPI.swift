//
//  FraportAPI.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation


struct FraportService {
    static var datetimeFormatter: NSDateFormatter = {
        let dateParser = NSDateFormatter()
        dateParser.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
        
        return dateParser
    }()
    
    let jsonFetcher = JSONFetcher()
    func fetchParkingForecast(flightReference: FlightReference, onSucces: (Array<ParkingFacility>)->(), onErrror: (JSONFetcherErrorType)->()) {
        let url = NSURL(string: "https://timetraveler-server.herokuapp.com/parkingAvailabilityForecast")
        func sucess(result: Array<ParkingFacility>) {
            
            dispatch_async(dispatch_get_main_queue(),{
                onSucces(result)
            })
            
        }
        
        jsonFetcher.loadArray(url!, onSucess: sucess, onError: onErrror)
    }
}

extension ParkingFacility: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let data = JSON["parkingFacility"] as! Dictionary<String, AnyObject>
        self.name = data["name"] as! String
        let longitude = data["longitude"] as! Double
        let latitude = data["latitude"] as! Double
        self.location = Location(latitude: latitude, longitude: longitude)
        self.forecastData = (data["latitude"] as! Array<Dictionary<String, AnyObject>>).map { forecast in
            return Forecast(JSON: forecast)
        }
        
    }
}

extension Forecast: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let dateTimeString = JSON["time"] as! String
        self.time = FraportService.datetimeFormatter.dateFromString(dateTimeString)!
        self.trend = JSON["trend"] as! String
        self.status = JSON["status"] as! String
    }
}
