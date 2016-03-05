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
    
    var locationOriginalFrame: CGRect?
   
   


    
    static func instanceFromNib() -> ProgressView {
        
        
        return UINib(nibName: "Progress", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ProgressView
    }
    
    func resetProgress()
    {
        setProgress(0, completed: false, sender:self)
        setProgress(1, completed: false, sender:self)
        setProgress(2, completed: false, sender:self)
        
    }
    
    func reselectRoute()
    {
        setProgress(2, completed: false, sender:self)
        
    }
    
   
     func setProgress(page: Int, completed: Bool, sender: AnyObject)
    {
        var imageItem: UIImageView!
        let imageName: String?
        var image: UIImage?
        switch(page)
        {
        case 1:
            imageName = "Baggage" + (completed ? " Ok" : "")
            imageItem = baggageIcon
            image = UIImage(named: imageName!)
            break
        case 2:
            imageName = "Location" + (completed ? " Ok" : "")
            imageItem = locationIcon
            image = UIImage(named: imageName!)
            break
        default:
            imageName = "Flight" + (completed ? " Ok" : "")
            imageItem = flightIcon
            image = UIImage(named: imageName!)
            break
        }
        
        let size: CGFloat = (completed ? 35 : 25)
        let posX: CGFloat = imageItem!.frame.origin.x
        let posY: CGFloat = imageItem!.frame.origin.y
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            imageItem!.frame = CGRectMake( (completed ? posX - 3.5 :  posX + 3.5), (completed ? posY - 5 :  posY + 5), size, size)
            
            }, completion: { (finished: Bool) -> Void in
                
                imageItem!.image = image
                
                if(page == 2 && completed)
                {
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc = storyboard.instantiateViewControllerWithIdentifier("JourneyStoryboard") as! JourneyViewController
                    let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
                    
                    vc.parentVC = sender as? SignUpPageViewController
                    sender.presentViewController(navController, animated: true, completion: nil)

                }

        })

        
    }

}
