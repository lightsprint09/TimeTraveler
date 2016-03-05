//
//  ParkingFacility.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

struct ParkingFacility {
    let name: String
    let location: Location
    let forecastData: Array<Forecast>
}

struct Forecast {
    let time: NSDate
    let trend: String
    let status: String
}