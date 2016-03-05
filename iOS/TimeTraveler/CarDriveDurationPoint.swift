//
//  CarDriveDurationPoint.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class CarDriveDurationPoint: DurationPoint {
    var duration: NSTimeInterval = 0
    let name = "Autofahrt zum Flughafen"
    var subtitle: String?
    
    let tabelCellID = "routeCell"
    
    var image = UIImage(named: "Bullet Point")!
    
    private let from: Location
    private let to: Location
    private let arrivalTime: NSDate?
    var direction: MKDirections!
    
    init(name: String, from: Location, to: Location, arrivalTime: NSDate? = nil) {
        self.from = from
        self.to = to
        self.arrivalTime = arrivalTime
    }
    
    
    func asyncResolve(onSucess: (NSTimeInterval) -> (), onError: (JSONFetcherErrorType) -> ()) {
        let request = MKDirectionsRequest()
        let origin = MKPlacemark(coordinate: from.locationCoordinate, addressDictionary: nil)
        let destination = MKPlacemark(coordinate: to.locationCoordinate, addressDictionary: nil)
        //use depature Dates
        request.arrivalDate = arrivalTime
        request.source = MKMapItem(placemark: origin)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .Automobile
        request.requestsAlternateRoutes = false
        
        direction = MKDirections(request: request)
        direction.calculateETAWithCompletionHandler { response, error in
            guard let response = response else {
                onError(.Network("Network map", error))
                return }
            self.duration = response.expectedTravelTime
            onSucess(response.expectedTravelTime)
        }

    }
    
    
}
