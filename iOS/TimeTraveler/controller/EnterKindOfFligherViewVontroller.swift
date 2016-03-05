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
        return true
    }
    @IBAction func sliderMoved(sender: AnyObject) {
        
        //snap to nearest
        let int = Int(speedSlider.value)
        travelSpeed = TravelSpeed(rawValue: int)!
        sender.setValue(Float(lroundf(speedSlider.value)), animated: true)
    }
    
    
    
    @IBAction func onCheckinLuggage(sender: AnyObject) {
        laguageType = .BigBag(nil)
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
        
    }

    @IBAction func finishEnteringData(sender: AnyObject) {
        travelerInformation.laguageType = laguageType
        travelerInformation.travelSpeed = travelSpeed
        passToNextViewController()
    }
}
