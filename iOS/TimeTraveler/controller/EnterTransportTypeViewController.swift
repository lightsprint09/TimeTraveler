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
    
    var autoOn: Bool = false
    var busBahnOn: Bool = false
    
    
    @IBOutlet weak var carETALabel: UILabel!
    @IBOutlet weak var TrainETALabel: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        
        
    }
    
    
    @IBAction func onAuto(sender: AnyObject) {
        autoOn = !autoOn
        
        let buttonImage = UIImage(named: "Auto" + (autoOn ? " selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
        
        
    }
    @IBAction func onBusBahn(sender: AnyObject) {
        busBahnOn = !busBahnOn
        
        let buttonImage = UIImage(named: "Bus and bahn" + (busBahnOn ? " selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
        
    }
    
    @IBAction func onNext(sender: AnyObject) {
        print("here");
    }
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
