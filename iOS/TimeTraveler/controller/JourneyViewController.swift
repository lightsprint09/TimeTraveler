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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()

        
        
    }
    
    func setupNavbar() {
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "Settings Icon"), forState: .Normal)
        btnBack.frame = CGRectMake(0, 0, 30, 30)
        btnBack.addTarget(self, action: Selector("reselectRoute"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let logo = UIImage(named: "Navbar logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let btnReset = UIButton()
        btnReset.setImage(UIImage(named: "Plus Icon"), forState: .Normal)
        btnReset.frame = CGRectMake(0, 0, 30, 30)
        btnReset.addTarget(self, action: Selector("resetJourney"), forControlEvents: .TouchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnReset
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    
    func reselectRoute()
    {
        parentVC!.reselectRoute()
        dismissView()
    }
    
    func dismissView()
    {
        
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetJourney()
    {
        parentVC!.resetProgress()
        
        dismissView()
    }
    
    
}
