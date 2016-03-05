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
    @IBOutlet weak var carETALabel: UILabel!
    @IBOutlet weak var TrainETALabel: UILabel!
    
    func calculateETACar() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = nil
        request.transportType = .Automobile
        request.requestsAlternateRoutes = false
        let direction = MKDirections(request: request)
        direction.calculateETAWithCompletionHandler { response, error in
            guard let response = response else { return }
            let time = response.expectedArrivalDate
        }
    }
}
