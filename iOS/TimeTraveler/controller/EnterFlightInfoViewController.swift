//
//  EnterFlightInfoViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnterFlightInfoViewController: EnteringViewController, UITextFieldDelegate {
    @IBOutlet weak var boockingReferenceIDInput: UITextField!
    @IBOutlet weak var flightIDInput: UITextField!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var nextButton: UIButton!
   
    //flightInfoView
    @IBOutlet weak var flightViewContainer: UIView!
    @IBOutlet weak var depatureAirportLabel: UILabel!
    @IBOutlet weak var depatureTimeLabel: UILabel!
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    @IBOutlet weak var arrivaleTimeLabel: UILabel!
    @IBOutlet weak var passegngerNameLabel: UILabel!
    @IBOutlet weak var countOfTravelersLabel: UILabel!
    @IBOutlet var flightCode: UILabel!
    @IBOutlet var flightStatus: UILabel!
    
    var flightReference: FlightReference?
    let flightStatusService = FlightStatusService()
    

    @IBAction func didChangeBoockingRederence(sender: UITextField) {
        guard let boockingReferenceID = sender.text where boockingReferenceID.characters.count > 4 else { return }
        flightReference = FlightReference(boockingReferenceID: boockingReferenceID, isValid: false)
        flightStatusService.fetchFlightStatus(flightReference!, onSucces: didChangeFlightStatus, onErrror: isInvalidFlightID)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        travelerInformation = TravelerInformation()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        boockingReferenceIDInput.delegate = self
        
    }
    
    func isInvalidFlightID(error: JSONFetcherErrorType) {
        print(error)
        
    }
    
//    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
//    {
//        textField.resignFirstResponder()
//        return true;
//    }

    
    func didChangeFlightStatus(flightStatus: FlightStatus) {
        travelerInformation.flightStatus = flightStatus
        displayFlightStatus(flightStatus)
        nextButton.enabled = true 
        boockingReferenceIDInput.resignFirstResponder()

    }
    
    func displayFlightStatus(flightStatus: FlightStatus) {
        flightViewContainer.hidden = false
        depatureAirportLabel.text = flightStatus.from?.airportCode
        depatureTimeLabel.text = flightStatus.from?.timeString
        
        arrivalAirportLabel.text = flightStatus.to?.airportCode
        arrivaleTimeLabel.text = flightStatus.to?.timeString
       // flightCode.text = flightStatus.
    }
    
    @IBAction func finishEnertingData(sender: AnyObject) {
        passToNextViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
    
    
    
    
}
