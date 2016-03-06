//
//  SignUpPageViewController.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 04.03.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//
import AVFoundation
import UIKit

class SignUpPageViewController: UIPageViewController, StandardPageViewController, UIGestureRecognizerDelegate {
    var controllers: Array<UIViewController> = []
    var currentControllerIndex = 0
    var player: AVPlayer?
    var progressIndicatorView: ProgressView!
    
    var displayedController: UIViewController {
        return viewControllers![0]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let keptVc: EnteringViewController = instantiateViewControllerWithIdentifier("enter_flight_controller")
        let mainVc: EnteringViewController = instantiateViewControllerWithIdentifier("enter_traveler_kind_controller")
        let tidiedOutVc: EnteringViewController = instantiateViewControllerWithIdentifier("enter_transport_controller")
        
        

                
        
        controllers = [keptVc, mainVc, tidiedOutVc]
//        let view: UIView = UIView.viewFromNibNamed("BackgroundBlurView", owner: self)
//        self.view.insertSubview(view, atIndex: 0)

        self.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        // load video
        playBackgroundvideo()
        
        // add bottoms status
        initProgressIndicators()
        
        
        
    }
    
    func initProgressIndicators()
    {
        
        progressIndicatorView = ProgressView.instanceFromNib()
        
        progressIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds),
        self.view.frame.size.height - 30.0)
        self.view.insertSubview(progressIndicatorView, atIndex: 3)
        
        
    }
    
    
   
    
    func playBackgroundvideo() {
        
        let backgroundView = UIImageView(frame: view.frame)
        //backgroundView.backgroundColor = .blackColor()
        backgroundView.image = UIImage(named: "Mask")
        backgroundView.alpha = 0.9
        view.insertSubview(backgroundView, atIndex: 0)
        
        let videoFile = NSBundle.mainBundle().pathForResource("opening_compressed", ofType: "mp4")
        player = AVPlayer(URL: NSURL(fileURLWithPath: videoFile!))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(playerLayer, atIndex: 0)        
        player!.seekToTime(kCMTimeZero)
        player!.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd", name: AVPlayerItemDidPlayToEndTimeNotification, object: player!.currentItem)
        
        
        //some parallax
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        self.view.addMotionEffect(group)
        
    }
    
    func playerItemDidReachEnd() {
        player!.seekToTime(kCMTimeZero)
        player!.play()
    }
    
    func nextProgress(){
        progressIndicatorView.setProgress(currentControllerIndex, completed: true, sender: self)
        currentControllerIndex += 1
        
    }
    
    func reselectRoute(){
        currentControllerIndex = 2
        progressIndicatorView.reselectRoute()
    }
    
    func resetProgress()
    {
        
        currentControllerIndex = 0
        let destnationViewController = controllers[currentControllerIndex] as! EnteringViewController
        
        progressIndicatorView.resetProgress()
        
        self.setViewControllers([destnationViewController], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
  
    func passToNextInputViewController(travelerInformation: TravelerInformation) {
        nextProgress()
        
        let destnationViewController = controllers[currentControllerIndex] as! EnteringViewController
        destnationViewController.travelerInformation = travelerInformation
        
        self.setViewControllers([destnationViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
}

extension SignUpPageViewController {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return getNthNextController(viewController, nthIndexInxex: -1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return getNthNextController(viewController, nthIndexInxex: 1)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
