//
//  State.swift
//  BrainyRL
//
//  Created by Richie on 2/11/19.
//  Copyright © 2019 CubitStudio. All rights reserved.
//

import Foundation

open class State: NSObject {
  public let stateId: Int
  public let position: CGPoint
  init(stateId: Int, position: CGPoint) {
    self.stateId = stateId
    self.position = position
  }
}
