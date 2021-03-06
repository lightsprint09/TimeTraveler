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
        return timeLinecontainer.addedHeader.count
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
        return timeLinecontainer.addedHeader.reverse()[indexPath.row]
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dataPoint = durationPointAtIndex(indexPath)
        return heightForCellID(dataPoint.tabelCellID)
    }
    
    func heightForCellID(cellID: String) -> CGFloat {
        switch cellID {
            case "routeCell":
            return 160
        case "headerFooter":
            return 60
        default:
            return 70
        }
    }
}

class JourneyViewController: UIViewController {
    @IBOutlet var ticketView: UIView!
    var ticketOpened: Bool = true
    
    @IBOutlet var arrivalTerminal: UILabel!
    @IBOutlet var arrivalTime: UILabel!
    @IBOutlet var seatNumber: UILabel!
    @IBOutlet var departureTerminal: UILabel!
    @IBOutlet var flightTime: UILabel!
    @IBOutlet var flightDate: UILabel!
    @IBOutlet var flightArrivalDestination: UILabel!
    @IBOutlet var flightDepartureDestination: UILabel!
    @IBOutlet var flightStatus: UILabel!
    @IBOutlet var flightNumber: UILabel!
    var travelerInformation: TravelerInformation!
    
    @IBOutlet var revealButton: UIButton!
    var timeLinecontainer: TimelineContainer {
        return travelerInformation.timeLineContainer
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
        
        flightStatus.text = travelerInformation?.flightStatusInfo?.status == "OT" ? "SCHEDULED" : "UNSCHEDULED"
        
        flightNumber.text = travelerInformation?.flightNumber
        
        departureTerminal.text = "Terminal " + (travelerInformation?.flightStatusInfo?.terminal)!
        flightDate.text = travelerInformation?.flightDate
        flightDepartureDestination.text = travelerInformation?.departureAirport
        flightArrivalDestination.text = travelerInformation?.arrivalAirport
        flightTime.text = travelerInformation?.departureTime
        arrivalTime.text = travelerInformation?.arrivalTime
        seatNumber.text = travelerInformation?.seatNumber
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        timeLinecontainer.asynResolve({res in
            self.tableView.reloadData()
            }, onError: { err in })
        setupNavbar()
        


        
        
        ticketView.layer.shadowColor = UIColor.blackColor().CGColor
        ticketView.layer.shadowOpacity = 0.5
        ticketView.layer.shadowOffset = CGSizeZero
        ticketView.layer.shadowRadius = 2
        ticketView.layer.shadowPath = UIBezierPath(rect: ticketView.bounds).CGPath
        
        self.ticketView.frame = CGRectMake(0, 451, self.ticketView.frame.size.width, self.ticketView.frame.size.height)

        revealButton.hidden = true

        UIView.animateWithDuration(0.3, delay: 1.0, options: UIViewAnimationOptions.TransitionNone
            , animations: {
            self.ticketView.frame = CGRectMake(0, 550, self.ticketView.frame.size.width, self.ticketView.frame.size.height)


            }, completion: {
                (value: Bool) in
                self.revealButton.hidden = false
        })
      
    }
    
    @IBAction func onBoardingCard(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone
            , animations: {
                self.ticketView.frame = CGRectMake(0, 520, self.ticketView.frame.size.width, self.ticketView.frame.size.height)
                
                
            }, completion: {
                (value: Bool) in
                self.revealButton.hidden = true
        })
        
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
                
                }, completion: {
                    (value: Bool) in
                    self.revealButton.hidden = (newY > 620 ? false : true)
            })
        }
        
    }
    
    
    func setupNavbar() {
        
        let btnBack = UIButton()
        let image = UIImage(named: "glyphicons-568-transport")
        
        btnBack.setImage(image, forState: .Normal)
        btnBack.tintColor = .grayColor()
        btnBack.frame = CGRectMake(0, 0, 30, 30)
        btnBack.addTarget(self, action: Selector("reselectRoute"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnBack
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let logo = UIImage(named: "Navbar logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
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
        travelerInformation = TravelerInformation()
        parentVC!.resetProgress()
        
        dismissView()
    }
    
    
}
