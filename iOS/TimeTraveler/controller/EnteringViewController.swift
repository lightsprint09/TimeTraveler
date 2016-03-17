//
//  EnteringViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class EnteringViewController: UIViewController {
    var travelerInformation: TravelerInformation!
    
    func passToNextViewController() {
        let parentController = self.parentViewController as? SignUpPageViewController
        parentController?.passToNextInputViewController(travelerInformation)
    }
}
