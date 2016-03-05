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
        
        
    }
    
    override func viewDidLayoutSubviews() {
        stylePageControl()
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
    
    func stylePageControl() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        
        
        pageControl.currentPageIndicatorTintColor = .orangeUIColor()
        pageControl.backgroundColor = UIColor.clearColor()
        
        
        self.view.layer.backgroundColor = UIColor.clearColor().CGColor
        
        
    }
    
    func passToNextInputViewController(travelerInformation: TravelerInformation) {
        currentControllerIndex += 1
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
