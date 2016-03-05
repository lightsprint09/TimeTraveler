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

    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var nextButton: UIButton!
    

    @IBAction func didChangeBoockingRederence(sender: UITextField) {
        guard let boockingReferenceID = sender.text else { return }
        flightReference = FlightReference(boockingReferenceID: boockingReferenceID, isValid: false)
        flightStatusService.fetchFlightStatus(flightReference!, onSucces: didChangeFlightStatus, onErrror: isInvalidFlightID)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        travelerInformation = TravelerInformation()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        nextButton.enabled = false
        
    }
    
    func isInvalidFlightID(error: NSError) {
        
    }
    
    func didChangeFlightStatus(flightStatus: FlightStatus) {
        travelerInformation.flightStatus = flightStatus

        //Activate Next button
    }

    @IBAction func didChangeFlightID(sender: UITextField) {
        // lookup
    }
    
    @IBAction func finishEnertingData(sender: AnyObject) {
        passToNextViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    
    
    
}
