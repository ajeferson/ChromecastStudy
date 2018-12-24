//
//  AppDelegate.swift
//  ChromecastStudy
//
//  Created by Alan Jeferson on 12/24/18.
//  Copyright © 2018 Alan Jeferson. All rights reserved.
//

import UIKit
import GoogleCast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupChromecast()
    return true
  }
  
  private func setupChromecast() {
    let criteria = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
    let options = GCKCastOptions(discoveryCriteria: criteria)
    GCKCastContext.setSharedInstanceWith(options)
    
    GCKLogger.sharedInstance().delegate = self
  }
}

// MARK: - GCKLogger Delegate

extension AppDelegate: GCKLoggerDelegate {
  func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
    print("[GCKCast] \(level): \(message)")
  }
}
