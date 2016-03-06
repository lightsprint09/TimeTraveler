//
//  AppDelegate.swift
//  TimeTraveler
//
//  Created by Lukas Schmidt on 25.02.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
        
        let notification = UILocalNotification()
        notification.alertBody = "Du bist jetzt im Bahnhof"
        
        let uuid = NSUUID(UUIDString: "BDC2CCD7-FCA3-43E6-A64F-6610351B1A5C")
        let major = UInt16(2200)
        let minor = UInt16(2)
        notification.region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "train_station")
        notification.regionTriggersOnce = true
        application.cancelAllLocalNotifications()
        application.scheduleLocalNotification(notification)

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(NSString(data: deviceToken, encoding: NSUTF8StringEncoding))
        print("\(deviceToken)")
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    let center = NSNotificationCenter.defaultCenter()
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        guard let id = notification.region?.identifier else { return }
        
        center.postNotificationName("beacon", object: id)
        
    }


}

