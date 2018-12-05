//
//  BranyEnvironment.swift
//  BrainyRL
//
//  Created by Richie on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

public enum States: Int {
  case terminal
  case penalty
}

open class BranyEnvironment: EnvironmentProtocol {

  public var actions = [Int]()
  public var states = [Int]()
  public var maximum_reward: Int?

  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool, info: String)

  init(){}

  public func getRandomAction() -> Int {
    let number = Int(arc4random_uniform(UInt32(actions.count-1)))
    return actions[number]
  }

  /// Take cction and get next observation and Reward:
  public func step(action: Int) -> NextStateAndReward {
    let state = states[action] // todo: VERIFY
    let reward = getReward(state: state)
    let isDone = state == States.terminal.rawValue
    return (next_state: state, reward: reward, done: isDone, info: "")
  }

  public func getReward(state: Int) -> Int {
    if state == States.terminal.rawValue {
      return 1
    } else if state == States.penalty.rawValue {
      return -1
    } else {
      return 0
    }
  }
}
