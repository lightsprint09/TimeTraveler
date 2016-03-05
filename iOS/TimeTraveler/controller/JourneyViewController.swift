//
//  JourneyViewController.swift
//  TimeTraveler
//
//  Created by Terenze Pro on 05/03/2016.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//


import UIKit

class JourneyViewController: UIViewController {
 
    var parentVC: SignUpPageViewController?
    
    @IBAction func onClose(sender: AnyObject) {
        
        parentVC!.resetProgress()

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
