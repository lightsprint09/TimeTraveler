//
//  EnterFlightInfoViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnterFlightInfoViewController: EnteringViewController, UITextFieldDelegate {
    @IBOutlet var logoImage: UIImageView!
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
    @IBOutlet weak var terminalLabel: UILabel!
    @IBOutlet var flightCodeLabel: UILabel!
    @IBOutlet var flightStatusLabel: UILabel!
    
    let flightStatusService = FlightStatusService()
    

    @IBAction func didChangeBoockingRederence(sender: UITextField) {
        guard let boockingReferenceID = sender.text where boockingReferenceID.characters.count > 4 else { return }
        travelerInformation.flightReference = FlightReference(boockingReferenceID: boockingReferenceID, isValid: false)
        flightStatusService.fetchFlightInformation(travelerInformation.flightReference!, onSucces: didChangeFlightStatus, onErrror: isInvalidFlightID)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        travelerInformation = TravelerInformation()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        boockingReferenceIDInput.delegate = self
        nextButton.backgroundColor = .grayColor()
        logoImage.image = logoImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

        logoImage.tintColor = UIColor.whiteColor()
    }
    
    func isInvalidFlightID(error: JSONFetcherErrorType) {
        print(error)
        
    }
    
    func didChangeFlightStatus(flightStatus: FlightStatus) {
        travelerInformation.flightStatus = flightStatus
        flightStatusService.fetchFlightStatus(flightStatus, onSucces: {info in
            self.travelerInformation.flightStatusInfo = info
            self.flightStatusLabel.text = info.status == "OT" ? "SCHEDULED" : "UNSCHEDULED"
            self.flightCodeLabel.text = flightStatus.segments.first?.marketingCarrier.flight
            self.terminalLabel.text = "Terminal \(info.terminal)"
            }, onErrror: { err in
        
        })
        displayFlightStatus(flightStatus)
        nextButton.enabled = true
        nextButton.backgroundColor = .orangeUIColor()
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
