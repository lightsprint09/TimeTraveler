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
        let url = NSURL(string: "https://time-traveler-api.herokuapp.com/parkingAvailabilityForecast")
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
        let priceData = (data["parkingSpaceTypes"] as! Array<Dictionary<String, AnyObject>>).last
        self.pricePerDay = (priceData!["fee_per_day"] as! Double)
        self.location = Location(latitude: latitude, longitude: longitude)
        self.forecastData = []
        
    }
}

extension Forecast: JSONParsable {
    init(JSON: Dictionary<String, AnyObject>) {
        let data = JSON["forecasts"] as! Dictionary<String, AnyObject>
        let dateTimeString = data["time"] as! String
        self.time = FraportService.datetimeFormatter.dateFromString(dateTimeString)!
        self.trend = data["trend"] as! String
        self.status = data["status"] as! String
    }
}
