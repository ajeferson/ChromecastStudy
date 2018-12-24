//
//  Logger.swift
//  ChromecastStudy
//
//  Created by Alan Jeferson on 12/24/18.
//  Copyright © 2018 Alan Jeferson. All rights reserved.
//

import Foundation

protocol Logger {
  func output(prefix: String, message: String)
}

extension Logger {
  func output(prefix: String = "GCKCast", message: String) {
    print("[\(prefix)] \(message)")
  }
}
