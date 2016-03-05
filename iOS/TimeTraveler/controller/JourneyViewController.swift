//
//  JourneyViewController.swift
//  TimeTraveler
//
//  Created by Terenze Pro on 05/03/2016.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//


import UIKit

class JourneyViewController: UIViewController {
    @IBOutlet var ticketView: UIView!
 
    var parentVC: SignUpPageViewController?
    let maxY:CGFloat = 591
    let minY:CGFloat = 691
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        
        
        ticketView.layer.shadowColor = UIColor.blackColor().CGColor
        ticketView.layer.shadowOpacity = 0.5
        ticketView.layer.shadowOffset = CGSizeZero
        ticketView.layer.shadowRadius = 2
        ticketView.layer.shadowPath = UIBezierPath(rect: ticketView.bounds).CGPath
        
    }
    
    override func viewDidLayoutSubviews() {
//        UIView.animateWithDuration(0.3, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
//            
//            
//            self.ticketView.frame = CGRectOffset(self.ticketView.frame, 0, 200)
//            
//            
//            }, completion: nil)

    }
    
    @IBAction func onPanTicket(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(self.view)
        
        
        let tmp1=sender.view?.center.y //y translation
        
        let newY = tmp1!+translation.y
        
        print("The y:\(newY)")

        if(newY < minY && newY > maxY){
            sender.view?.center=CGPointMake(self.view.frame.size.width / 2, newY)
            sender.setTranslation(CGPointZero, inView: self.view)

        }
        
        if(sender.state ==  UIGestureRecognizerState.Ended){
            //reposition to nearest
            UIView.animateWithDuration(0.3, animations: {
                
                sender.view?.center=CGPointMake(self.view.frame.size.width / 2, (newY > 620 ? self.minY : self.maxY))
                sender.setTranslation(CGPointZero, inView: self.view)
                
                }, completion: nil)
        }
        
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
