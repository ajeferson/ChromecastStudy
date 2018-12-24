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
  
  private var castContext: GCKCastContext {
    return GCKCastContext.sharedInstance()
  }
  private var sessionManager: GCKSessionManager {
    return castContext.sessionManager
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupChromecastButton()
  }
  
  private func setupChromecastButton() {
    let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
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

// MARK: - Logger

extension ViewController: Logger {}
