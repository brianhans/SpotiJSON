//
//  AppDelegate.swift
//  SpotiJSON
//
//  Created by Brian Hans on 7/4/16.
//  Copyright © 2016 Brian Hans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        SpotifyAPIManager.sharedInstance.processOAuthStep1Response(url)
        return true
    }


}

