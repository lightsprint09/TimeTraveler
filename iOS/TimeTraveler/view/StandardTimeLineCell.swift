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
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    func dispayDurationPoint(durationPoint: DurationPoint) {
        titleLabel.text = durationPoint.name
        timeLabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(durationPoint.duration)
        //infoImageView.image = durationPoint.passed ? UIImage(named: "Parking")! : durationPoint.image
        infoImageView.image = durationPoint.image
        self.contentView.alpha = durationPoint.passed ? 0.1 : 1
        dateTimeLabel.text = FlightStatusService.timeFormatter.stringFromDate(durationPoint.targetDate)

    }
}

class RouteCell: UITableViewCell, DurationPointDisplayable {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func dispayDurationPoint(durationPoint: DurationPoint) {
        titleLabel.text = durationPoint.name
        infoImageView.image = durationPoint.image
        
        
    
        timeLabel.text = EnterTransportTypeViewController.hoursFormatter.stringFromTimeInterval(durationPoint.duration)
        guard let carPoint = durationPoint as? CarDriveDurationPoint else { return }
        
        
        
        for route in carPoint.routes as [MKRoute] {
            
            mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            
        }
        
        if let first = mapView.overlays.first {
            let rect = mapView.overlays.reduce(first.boundingMapRect, combine: {MKMapRectUnion($0, $1.boundingMapRect)})
            mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0), animated: true)
        }


        self.contentView.alpha = durationPoint.passed ? 0.1 : 1

        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
            return renderer
    }

    
    
}
