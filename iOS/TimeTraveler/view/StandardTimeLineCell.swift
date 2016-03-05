//
//  StandardTimeLineCell.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 05.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit

protocol DurationPointDisplayable {
    func dispayDurationPoint(durationPoint: DurationPoint)
}

class StandardTimeLineCell: UITableViewCell, DurationPointDisplayable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func dispayDurationPoint(durationPoint: DurationPoint) {
        titleLabel.text = durationPoint.name
        timeLabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(durationPoint.duration)
    }
}

class RouteCell: UITableViewCell, DurationPointDisplayable {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func dispayDurationPoint(durationPoint: DurationPoint) {
        titleLabel.text = durationPoint.name
        timeLabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(durationPoint.duration)
        guard let carPoint = durationPoint as? CarDriveDurationPoint else { return }
        
        
    }
}
