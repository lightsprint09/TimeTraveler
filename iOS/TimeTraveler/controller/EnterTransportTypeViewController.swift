//
//  EnterTransportTypeViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit

extension EnterTransportTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return parkingFacilitys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = transportType == .Car ? "parking_cell" : "train_cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        if let parkCell = cell as? ParkingTableViewCell {
            parkCell.configureWithParkingFacility(parkingFacilitys[indexPath.row])
            return parkCell
        }
        if let trainCell = cell as? TrainTripTableViewCell {
            //
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ParkingTableViewCell where transportType == .Car {
            didSelectNewTimePoint(cell.carTimePoint)
            cell.holderImage.image = UIImage(named: "Selected Layer")
            cell.dottedLine.image = UIImage(named: "Selection Way")
            
            
          
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrainTripTableViewCell where transportType == .PlublicTransport {
            
            cell.holderImage.image = UIImage(named: "Selected Layer")
            cell.dottedLine.image = UIImage(named: "Selection Way")
            
            
            
        }
        nextButton.backgroundColor = .orangeUIColor()
        nextButton.enabled = true

    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ParkingTableViewCell where transportType == .Car {
            cell.holderImage.image = UIImage(named: "Unselected Layer")
            cell.dottedLine.image = UIImage(named: "Unselected Way")
            didSelectNewTimePoint(cell.carTimePoint)
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrainTripTableViewCell where transportType == .PlublicTransport {
            cell.holderImage.image = UIImage(named: "Unselected Layer")
            cell.dottedLine.image = UIImage(named: "Unselected Way")
            //didSelectNewTimePoint(cell.carTimePoint)
        }

        
    }


}

class EnterTransportTypeViewController: EnteringViewController {
    var transportType: TransportType? {
        didSet {
            tableView.reloadData()
            let image = UIImage(named: (transportType == .Car ?"Icon Auto" : "Icon Train"));
           transportImage.image = image
        }
    }
    var autoOn: Bool = false
    var busBahnOn: Bool = false
    var parkingFacilitys = Array<ParkingFacility>()

    let rmvService = RMVService()
    let parkingService = FraportService()
    
    @IBOutlet var endView: UIView!
    @IBOutlet var startView: UIView!
    @IBOutlet weak var transportImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var ETAFlightLabel: UILabel!
    @IBOutlet weak var carETALabel: UILabel!
    @IBOutlet weak var trainETALabel: UILabel!
    
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var nextButton: UIButton!
    
    var basicCarDuration: DurationPoint!
    static var hoursFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.allowedUnits = NSCalendarUnit.Hour.union(.Minute)
        formatter.unitsStyle = .Short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor.clearColor()
        nextButton.layer.cornerRadius = 5
        nextButton.backgroundColor = .grayColor()
        
        nextButton.enabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        startView.hidden = true
        endView.hidden = true
        basicCarDuration = CarDriveDurationPoint(name: "Autofahrt", from: LocationConstants.currentLocation, to: LocationConstants.airportLocation)
        basicCarDuration.asyncResolve({time in
            dispatch_async(dispatch_get_main_queue(),{
               self.carETALabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(time)
            })
            }, onError: {err in
        })
        travelerInformation.timeLineContainer.durationPoints.append(FakeDurationPoint(name: "", duration: 0))
        travelerInformation.timeLineContainer.asynResolve({result in
            print(result)
            }, onError: { err in
        })
        
        
        parkingService.fetchParkingForecast(travelerInformation.flightReference!, onSucces: {list in
            self.parkingFacilitys = list
            }, onErrror: { err in
                print(err)
        })
        rmvService.fetchRMVTrip(LocationConstants.currentLocation, onSucces: didFetchRMVTrip, onErrror: onErrorFetchingRMVTrip)
        
        
       
    }
        func didFetchRMVTrip(rmvTrip: RMVRoute) {
            let sortedTrips = rmvTrip.trips.sort { trip1, trip2 in
                return trip1.duration < trip2.duration
            }
            guard let trainDuration = sortedTrips.first?.duration else { return }
            trainETALabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(trainDuration)
            
        }
        
        func onErrorFetchingRMVTrip(error: JSONFetcherErrorType) {
            print(error)
            
        }
    func didSelectNewTimePoint(duration: DurationPoint) {
        travelerInformation.timeLineContainer.durationPoints.popLast()
        travelerInformation.timeLineContainer.durationPoints.append(duration)
        ETALabel.text = FlightStatusService.timeFormatter.stringFromDate(travelerInformation.timeLineContainer.currentResultTime.date) + " Abfahrt vom Aufenthaltsort"
        let duration = travelerInformation.timeLineContainer.durationPoints.last!.duration
        durationLabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(duration)! + " bei vorraussichtlichem Verkehr"
        
        
        
    }
    
    

    
    @IBAction func onAuto(sender: AnyObject) {
        didSelectNewTimePoint(basicCarDuration)
        transportType = .Car
        displayButtonState()
    }
    
    func displayButtonState() {
        let busButtonImage = UIImage(named: "Bus and bahn" + (transportType == .PlublicTransport ? " selected" : ""));
        let carButtonImage = UIImage(named: "Auto" + (transportType == .Car ? " selected" : ""));
        startView.hidden = false
        endView.hidden = false
        carButton.setImage(carButtonImage, forState: .Normal)
        busButton.setImage(busButtonImage, forState: .Normal)

    }
    
    @IBAction func onBusBahn(sender: AnyObject) {
        guard transportType != .PlublicTransport else { return }
        transportType = .PlublicTransport
        displayButtonState()  
    }
    
    @IBAction func onJourney(sender: AnyObject) {
        let parentController = self.parentViewController as? SignUpPageViewController
        parentController?.nextProgress()
        
        let vc: JourneyViewController = instantiateViewControllerWithIdentifier("JourneyStoryboard")
        vc.travelerInformation = travelerInformation
        let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        vc.parentVC = parentController
        self.presentViewController(navController, animated: true, completion: nil)
        
        

    }
    
}