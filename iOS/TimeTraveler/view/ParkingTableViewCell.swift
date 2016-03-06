//
//  PackingTableViewCell.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var parkingSubtitleLable: UILabel!
    @IBOutlet var holderImage: UIImageView!
    @IBOutlet var dottedLine: UIImageView!
    
    var carTimePoint: CarDriveDurationPoint!
    func configureWithParkingFacility(facility: ParkingFacility) {
        parkingNameLabel.text = facility.name
        
        carTimePoint = CarDriveDurationPoint(name: "Fahrt zum Parkplatz", from: LocationConstants.currentLocation, to: facility.location)
        carTimePoint.asyncResolve({time in
            dispatch_async(dispatch_get_main_queue(),{
                self.parkingSubtitleLable.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(time)! + " Fahrzeit - pro Tag: \(facility.pricePerDay)€"
            })
            }, onError: { err in
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            holderImage.image = UIImage(named: "Selected Layer")
            dottedLine.image = UIImage(named: "Selection Way")
        }else {
            holderImage.image = UIImage(named: "Unselected Layer")
            dottedLine.image = UIImage(named: "Unselected Way")
        }
    }
}

class TrainTripTableViewCell: UITableViewCell {
    @IBOutlet var holderImage: UIImageView!
    
    @IBOutlet var dottedLine: UIImageView!
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var parkingSubtitleLable: UILabel!
    
    var trainTripDuration: LocalTrainDurationPoint!
    
    func configureWithTrip(trip: RMVTrip) {
        trainTripDuration = LocalTrainDurationPoint(rmvTrip: trip)
        parkingNameLabel.text = trip.legs.last?.destination?.name
        let durationString = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(trip.duration!)!
        parkingSubtitleLable.text = "\(durationString) Fahrzeit - \(trip.legs.count) Umstiege"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            holderImage.image = UIImage(named: "Selected Layer")
            dottedLine.image = UIImage(named: "Selection Way")
        }else {
            holderImage.image = UIImage(named: "Unselected Layer")
            dottedLine.image = UIImage(named: "Unselected Way")
        }
    }
}
