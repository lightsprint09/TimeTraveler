//
//  ProgressView.swift
//  TimeTraveler
//
//  Created by Terenze Pro on 05/03/2016.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit

class ProgressView: UIView {
   
    @IBOutlet var locationIcon: UIImageView!
    @IBOutlet var baggageIcon: UIImageView!
    @IBOutlet var flightIcon: UIImageView!
    static func instanceFromNib() -> ProgressView {
        return UINib(nibName: "Progress", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ProgressView
    }
    
    
     func setProgress(page: Int, completed: Bool)
    {
        var imageItem: UIImageView!
        let imageName: String?
        var image: UIImage?
        switch(page)
        {
        case 1:
            imageName = "Baggage Ok"
            imageItem = baggageIcon
            image = UIImage(named: imageName!)
            break
        case 2:
            imageName = "Location Ok"
            imageItem = locationIcon
            image = UIImage(named: imageName!)
            break
        default:
            imageName = "Flight Ok"
            imageItem = flightIcon
            image = UIImage(named: imageName!)
            break
        }
        
        
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            imageItem!.frame = CGRectMake(imageItem!.frame.origin.x - 5, imageItem!.frame.origin.y - 5, 35, 35)
            
            }, completion: { (finished: Bool) -> Void in
                
                
                imageItem!.image = image

        })

        
    }

}
