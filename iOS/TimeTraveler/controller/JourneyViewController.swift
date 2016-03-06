//
//  JourneyViewController.swift
//  TimeTraveler
//
//  Created by Terenze Pro on 05/03/2016.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//


import UIKit

extension JourneyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLinecontainer.durationPoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataPoint = durationPointAtIndex(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(dataPoint.tabelCellID, forIndexPath: indexPath)
        
        if let typecell = cell as? DurationPointDisplayable {
            typecell.dispayDurationPoint(dataPoint)
            return typecell as! UITableViewCell
        }
        
        return cell
    }
    
    func durationPointAtIndex(indexPath: NSIndexPath) -> DurationPoint {
        return timeLinecontainer.durationPoints.reverse()[indexPath.row]
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dataPoint = durationPointAtIndex(indexPath)
        return heightForCellID(dataPoint.tabelCellID)
    }
    
    func heightForCellID(cellID: String) -> CGFloat {
        switch cellID {
            case "routeCell":
            return 160
        default:
            return 70
        }
    }
}

class JourneyViewController: UIViewController {
    @IBOutlet var ticketView: UIView!
    var travelerInformation: TravelerInformation!
    
    var timeLinecontainer: TimelineContainer {
        return travelerInformation.timeLineContainer
    }
    @IBAction func onBoardingCard(sender: AnyObject) {
        
    }
 
    var parentVC: SignUpPageViewController?
    let maxY:CGFloat = 591
    let minY:CGFloat = 691
    let center = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    func update() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        center.addObserver(self, selector: "update", name: "update", object: nil)
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        timeLinecontainer.asynResolve({res in
            self.tableView.reloadData()
            }, onError: { err in })
        setupNavbar()
        
        
//        for cell in tableView.visibleCells {
//            
//        }
//        for (var row = 0; row < tableView.numberOfRowsInSection(0); row++)
//        {
//            
//            let indexPath = NSIndexPath(forRow: row, inSection: 0)
//            
//            let cell :UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//            
//          //  let delayTime: Float = row * 0.1
//           //cell.contentView.alpha = 0
//            
//            let view = cell.contentView
//            view.alpha = 0.1
//            
//            UIView.animateWithDuration(2.5, delay: 5, options: [], animations: { () -> Void in
//                view.alpha = 1
//                }, completion: nil)
//            
//        }

        
        
        ticketView.layer.shadowColor = UIColor.blackColor().CGColor
        ticketView.layer.shadowOpacity = 0.5
        ticketView.layer.shadowOffset = CGSizeZero
        ticketView.layer.shadowRadius = 2
        ticketView.layer.shadowPath = UIBezierPath(rect: ticketView.bounds).CGPath
        
        self.ticketView.frame = CGRectMake(0, 451, self.ticketView.frame.size.width, self.ticketView.frame.size.height)
        UIView.animateWithDuration(0.3, delay: 1.0, options: UIViewAnimationOptions.TransitionNone
            , animations: {
            self.ticketView.frame = CGRectMake(0, 550, self.ticketView.frame.size.width, self.ticketView.frame.size.height)

            
            }, completion: nil)
      
    }
    
    @IBAction func onPanTicket(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        
        
        let tmp1 = sender.view?.center.y //y translation
        
        let newY = tmp1!+translation.y
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
