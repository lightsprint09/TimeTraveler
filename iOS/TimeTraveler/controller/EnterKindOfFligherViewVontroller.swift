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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        nextButton.enabled = false
        
    }

}
