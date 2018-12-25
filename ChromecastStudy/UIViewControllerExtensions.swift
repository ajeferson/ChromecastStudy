//
//  UIViewControllerExtensions.swift
//  ChromecastStudy
//
//  Created by Alan Jeferson on 12/25/18.
//  Copyright © 2018 Alan Jeferson. All rights reserved.
//

import Foundation
import GoogleCast

extension UIViewController {
  var castContext: GCKCastContext {
    return GCKCastContext.sharedInstance()
  }
  
  func setupChromecastButton() {
    let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
  }
}

// MARK: - Logger

extension UIViewController: Logger {}
