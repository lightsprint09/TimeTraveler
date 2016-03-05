//
//  EnterTransportTypeViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit

class EnterTransportTypeViewController: EnteringViewController {
    var transportType: TransportType?
    let rmvService = RMVService()
    @IBOutlet weak var carETALabel: UILabel!
    @IBOutlet weak var TrainETALabel: UILabel!
    
    override func viewDidLoad() {
        let location = Location(latitude: 50.111806, longitude: 8.681087)
        rmvService.fetchRMVTrip(location, onSucces: didFetchRMVTrip, onErrror: onErrorFetchingRMVTrip)
        calculateETACar(location, to: Location(latitude: 50.031936, longitude: 8.577776))
    }
    
    func didFetchRMVTrip(rmvTrip: RMVRoute) {
        for (_, trip) in rmvTrip.trips.enumerate() {
            print((trip.duration ?? 0) / 60)
        }
    }
    
    func onErrorFetchingRMVTrip(error: JSONFetcherErrorType) {
        print(error)
        
    }
    
    func calculateETACar(from: Location, to: Location) {
        let request = MKDirectionsRequest()
        let origin = MKPlacemark(coordinate: from.locationCoordinate, addressDictionary: nil)
        let destination = MKPlacemark(coordinate: to.locationCoordinate, addressDictionary: nil)
        //use depature Dates
        request.source = MKMapItem(placemark: origin)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .Automobile
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculateETAWithCompletionHandler { response, error in
            guard let response = response else { return }
            let time = response.expectedTravelTime / 60
            print(response.distance / 1000, time)
        }
    }
}
