//
//  EnvironmentProtocols.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/5/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

public protocol EnvironmentProtocol {
  var actions: [Int] { get set}
  var states: [Int] { get set}
  var maximum_reward: Int?  { get set}
  func getRandomAction() -> Int
}
