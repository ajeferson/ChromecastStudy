//
//  ViewController.swift
//  ChromecastStudy
//
//  Created by Alan Jeferson on 12/24/18.
//  Copyright © 2018 Alan Jeferson. All rights reserved.
//

import UIKit
import GoogleCast

class ViewController: UIViewController {
  private var sessionManager: GCKSessionManager {
    return castContext.sessionManager
  }
  
  @IBOutlet var miniMediaControlsContainerView: UIView!
  @IBOutlet var miniMediaControlsHeightConstraint: NSLayoutConstraint!
  
  private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController?
  var miniMediaControlsViewEnabled = false {
    didSet {
      if self.isViewLoaded {
        updateControlBarsVisibility()
      }
    }
  }
  
  var overridenNavigationController: UINavigationController?
  override var navigationController: UINavigationController? {
    get {
      return overridenNavigationController
    }
    set {
      overridenNavigationController = newValue
    }
  }
  
  var miniMediaControlsItemEnabled = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupChromecastButton()

    miniMediaControlsViewEnabled = true
    miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
    miniMediaControlsViewController?.delegate = self
    updateControlBarsVisibility()
    install(viewController: miniMediaControlsViewController,
            inContainerView: miniMediaControlsContainerView)
  }
  
  private func updateControlBarsVisibility() {
    guard let miniMediaControlsViewController = miniMediaControlsViewController else {
      output(message: "MiniMediaControlsViewController is nil")
      return
    }
    
    if miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
      miniMediaControlsHeightConstraint.constant = miniMediaControlsViewController.minHeight
      view.bringSubviewToFront(miniMediaControlsContainerView)
    } else {
      miniMediaControlsHeightConstraint.constant = 0
    }
    
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
    self.view.setNeedsLayout()
  }
  
  private func install(viewController: UIViewController?, inContainerView containerView: UIView) {
    guard let viewController = viewController else {
      output(message: "Can not install a nil view controller")
      return
    }
    
    addChild(viewController)
    viewController.view.frame = containerView.bounds
    containerView.addSubview(viewController.view)
    viewController.didMove(toParent: self)
  }
  
  private func uninstall(viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
  
  // MARK: - Actions
  
  @IBAction func didTouchPlayButton() {
    let metadata = GCKMediaMetadata(metadataType: .generic)
    metadata.setString("This is the title", forKey: kGCKMetadataKeyTitle)
    metadata.setString("Cool subtitle", forKey: kGCKMetadataKeySubtitle)
    
    guard let imageUrl = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg") else {
      return
    }
    let image = GCKImage(url: imageUrl,
                         width: 2000,
                         height: 2000)
    metadata.addImage(image)
    
    let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    guard let mediaURL = url else {
      print("invalid mediaURL")
      return
    }
    
    let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: mediaURL)
    mediaInfoBuilder.streamType = .none // ??
    mediaInfoBuilder.contentType = "video/mp4"
    mediaInfoBuilder.metadata = metadata
    let mediaInformation = mediaInfoBuilder.build()
    
    castContext.presentDefaultExpandedMediaControls()
    guard let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation) else {
      return
    }
    
    request.delegate = self
  }
}

// MARK: - GCKRequest Delegate

extension ViewController: GCKRequestDelegate {
  func requestDidComplete(_ request: GCKRequest) {
    output(message: "Request did complete")
  }
  
  func request(_ request: GCKRequest, didFailWithError error: GCKError) {
    output(message: "Request did fail with error: \(error)")
  }
  
  func request(_ request: GCKRequest, didAbortWith abortReason: GCKRequestAbortReason) {
    output(message: "Request did abort with reason: \(abortReason)")
  }
}

// MARK: - GCKUIMiniMediaControlsViewController Delegate

extension ViewController: GCKUIMiniMediaControlsViewControllerDelegate {
  func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
    updateControlBarsVisibility()
  }
}
