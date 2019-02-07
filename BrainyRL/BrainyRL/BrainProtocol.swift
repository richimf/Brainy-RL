//
//  BrainProtocol.swift
//  BrainyRL
//
//  Created by Richie on 2/7/19.
//  Copyright © 2019 CubitStudio. All rights reserved.
//

import Foundation

public protocol BrainProtocol: class {
  // Set Up an Environment, it is mandatory
  var environment: BrainyEnvironment? { get set}
  func think(steps: Int, episodes: Int) throws
  func forget()
}
