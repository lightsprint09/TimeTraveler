//
//  EnterFlightInfoViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnterFlightInfoViewController: EnteringViewController {
    @IBOutlet weak var boockingReferenceIDInput: UITextField!
    @IBOutlet weak var flightIDInput: UITextField!
    
    var flightReference: FlightReference?
    
    let flightStatusService = FlightStatusService()
    
    override func viewDidLoad() {
        travelerInformation = TravelerInformation()
    }

    @IBAction func didChangeBoockingRederence(sender: UITextField) {
        guard let boockingReferenceID = sender.text else { return }
        flightReference = FlightReference(boockingReferenceID: boockingReferenceID, isValid: false)
        flightStatusService.fetchFlightStatus(flightReference!, onSucces: didChangeFlightStatus, onErrror: isInvalidFlightID)
        
    }
    
    func isInvalidFlightID(error: NSError) {
        
    }
    
    func didChangeFlightStatus(flightStatus: FlightStatus) {
        travelerInformation.flightStatus = flightStatus

        //Activate Next button
    }

    @IBAction func didChangeFlightID(sender: UITextField) {
        
    }
    
    @IBAction func finishEnertingData(sender: AnyObject) {
        passToNextViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    
    
    
}
