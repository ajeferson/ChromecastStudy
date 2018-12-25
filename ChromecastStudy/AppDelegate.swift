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
//    setupCastContainer()
    return true
  }
  
  private func setupChromecast() {
    let criteria = GCKDiscoveryCriteria(applicationID: kGCKDefaultMediaReceiverApplicationID)
    let options = GCKCastOptions(discoveryCriteria: criteria)
    GCKCastContext.setSharedInstanceWith(options)
    
    GCKLogger.sharedInstance().delegate = self
  }
  
  private func setupCastContainer() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
      return
    }
    let container = GCKCastContext.sharedInstance().createCastContainerController(for: navigationController)
    container.miniMediaControlsViewController?.view.backgroundColor = .red
    container.miniMediaControlsItemEnabled = true
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = container
    window?.makeKey()
  }
}

// MARK: - GCKLogger Delegate

extension AppDelegate: GCKLoggerDelegate {
  func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
    output(message: "\(level): \(message)")
  }
}

// MARK: - Logger

extension AppDelegate: Logger {}
