//
//  BranyEnvironment.swift
//  BrainyRL
//
//  Created by Richie on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

open class BranyEnvironment: EnvironmentProtocol {

  public var actions = [Int]()
  public var states = [Int]()
  public var maximum_reward: Int?

  init(){}

  public func getRandomAction() -> Int {
    let number = Int(arc4random_uniform(UInt32(actions.count-1)))
    return actions[number]
  }

}
