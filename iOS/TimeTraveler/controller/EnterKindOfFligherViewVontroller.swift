//
//  EnterKindOfFligherViewVontroller.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnterKindOfFligherViewVontroller: EnteringViewController {
    var laguageType: LaguageType? {
        didSet {
            nextButton.enabled = isValidInput()
        }
    }
    var travelSpeed: TravelSpeed = .Medium
    
    var handLuggageOn: Bool = false
    var checkinLuggageOn: Bool = false
    
    @IBOutlet var slideView: UIView!
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    
    func isValidInput() -> Bool {
        guard let _ = laguageType else { return false }
        nextButton.backgroundColor = .orangeUIColor()
        return true
    }
    @IBAction func sliderMoved(sender: AnyObject) {
        
        //snap to nearest
        let int = Int(speedSlider.value)
        
        travelSpeed = TravelSpeed(rawValue: int)!
        switch travelSpeed {
        case .Slow:
            TravelSpeed.multiplier = 1.5
            break
        case .Medium:
            TravelSpeed.multiplier = 1
            break
        case .Fast:
            TravelSpeed.multiplier = 0.8
            break
            
        }
        sender.setValue(Float(lroundf(speedSlider.value)), animated: true)
    }
    
    
    
    @IBAction func onCheckinLuggage(sender: AnyObject) {
        laguageType = .BigBag
        checkinLuggageOn = !checkinLuggageOn
        if checkinLuggageOn && handLuggageOn {
            laguageType = .Both
        }
        let buttonImage = UIImage(named: "Check in luggage" + (checkinLuggageOn ? " selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
    }
    @IBAction func onHandLuggage(sender: AnyObject) {
        laguageType = .Handbag
        handLuggageOn = !handLuggageOn
        if checkinLuggageOn && handLuggageOn {
            laguageType = .Both
        }
        
        let buttonImage = UIImage(named: "Hand Luggage" + (handLuggageOn ? " Selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = .clearColor()
        nextButton.layer.cornerRadius = 5
        slideView.layer.cornerRadius = 5
        nextButton.backgroundColor = .grayColor()
        
    }

    @IBAction func finishEnteringData(sender: AnyObject) {
        guard let gateName = travelerInformation.flightStatusInfo?.gate else { return }
        let gate = gateName.substringToIndex(gateName.startIndex.successor())
        let boaring = FakeDurationPoint(name: "Boarding", duration: 60 * 25)
        let checkInToSec = WalkingDistanceDurationPoint(origin: "Check-In A", destination: "Central Security-Check A")
        let fromSecToGate: DurationPoint = WalkingDistanceDurationPoint(origin: "Central Security-Check A", destination: "\(gate)-Gates")
        let security = FakeDurationPoint(name: "Security Check", duration: 60 * 28)
        var checkin: DurationPoint
        if laguageType == .Both || laguageType == .BigBag {
            checkin = FakeDurationPoint(name: "Check-In & Gepäckabgabe", duration: 60 * 24)
            
        }else {
            checkin = FakeDurationPoint(name: "Check-In", duration: 60 * 18)
        }
        travelerInformation.timeLineContainer.durationPoints.appendContentsOf([boaring, fromSecToGate, security, checkInToSec, checkin])
        
        travelerInformation.laguageType = laguageType
        travelerInformation.travelSpeed = travelSpeed
        passToNextViewController()
    }
}
