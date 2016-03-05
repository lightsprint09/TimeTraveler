//
//  EnterKindOfFligherViewVontroller.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnterKindOfFligherViewVontroller: EnteringViewController {
    var laguageType: LaguageType?
    var travelSpeed: TravelSpeed?
    
    var handLuggageOn: Bool = false
    var checkinLuggageOn: Bool = false
    
    @IBOutlet var slideView: UIView!
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    
    func isValidInput() -> Bool {
        guard let _ = laguageType, let _ = travelSpeed else { return false }
        return true
    }
    @IBAction func sliderMoved(sender: AnyObject) {
        
        //snap to nearest
        sender.setValue(Float(lroundf(speedSlider.value)), animated: true)
    }
    
    
    
    @IBAction func onCheckinLuggage(sender: AnyObject) {
        checkinLuggageOn = !checkinLuggageOn
        
        let buttonImage = UIImage(named: "Check in luggage" + (checkinLuggageOn ? " selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
        
        
    }
    @IBAction func onHandLuggage(sender: AnyObject) {
        handLuggageOn = !handLuggageOn
        
        let buttonImage = UIImage(named: "Hand Luggage" + (handLuggageOn ? " Selected" : ""));
        sender.setImage(buttonImage, forState: .Normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        nextButton.enabled = false
        slideView.layer.cornerRadius = 5
        
    }

}
