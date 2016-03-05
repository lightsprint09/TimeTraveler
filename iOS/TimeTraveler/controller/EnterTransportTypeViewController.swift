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
    var autoOn: Bool = true
    var busBahnOn: Bool = false
    
    @IBOutlet var buttonBus: UIButton!
    @IBOutlet var buttonAuto: UIButton!
    let rmvService = RMVService()
    var timeLineContainer: TimelineContainer!
    
    let airportLocation = Location(latitude: 50.031936, longitude: 8.577776)
    @IBOutlet weak var carETALabel: UILabel!
    @IBOutlet weak var TrainETALabel: UILabel!
    
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineContainer = TimelineContainer(targetTime: travelerInformation.targetTime)
        let location = Location(latitude: 50.111806, longitude: 8.681087)
        let carTimePoint = CarDriveDurationPoint(name: "Autofahrt", from: location, to: airportLocation)
        timeLineContainer.addDurationPoint(carTimePoint)
        print(timeLineContainer.currentResultTime)
        timeLineContainer.asynResolve({result in
            print(result)
            }, onError: { err in
        })
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        
        
        rmvService.fetchRMVTrip(location, onSucces: didFetchRMVTrip, onErrror: onErrorFetchingRMVTrip)
        
    }
        func didFetchRMVTrip(rmvTrip: RMVRoute) {
            for (_, trip) in rmvTrip.trips.enumerate() {
                //print((trip.duration ?? 0) / 60)
            }
        }
        
        func onErrorFetchingRMVTrip(error: JSONFetcherErrorType) {
            print(error)
            
        }
    

    @IBAction func onAuto(sender: AnyObject) {
        transportType = .Car
        displayButtonState()    }
    
    func displayButtonState() {
        let busButtonImage = UIImage(named: "Bus and bahn" + (transportType == .PlublicTransport ? " selected" : ""));
        let carButtonImage = UIImage(named: "Auto" + (transportType == .Car ? " selected" : ""));
        carButton.setImage(carButtonImage, forState: .Normal)
        busButton.setImage(busButtonImage, forState: .Normal)

    }
    
    @IBAction func onBusBahn(sender: AnyObject) {
        transportType = .PlublicTransport
        displayButtonState()  
    }
    
    
}