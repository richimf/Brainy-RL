//
//  BranyEnvironment.swift
//  BrainyRL
//
//  Created by Richie on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

// THIS IS A MODEL OF THE ENVIRONMENT
open class BranyEnvironment {

  public var maximum_reward: Int?
  public var action_space = [Int]()
  public var states = [Int]()
  public var penalty_states = [Int]()
  public var terminal_states = [Int]()

  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool)

  init(){}

  public func getRandomAction() -> Int {
    let number = Int(arc4random_uniform(UInt32(action_space.count-1)))
    return action_space[number]
  }

  /// Take cction and get next observation and Reward:
  ///  THIS FUNCTION TELLS THE AGENT WHERE TO MOVE NEXT
  public func step(action: Int) -> NextStateAndReward {
    let next_state = whereToMove(action: action)
    let reward = getReward(state: next_state)
    let isDone = isTerminalState(state: next_state)
    return (next_state: next_state, reward: reward, done: isDone)
  }

  public func whereToMove(action: Int) -> Int {
    //TODO: SETUP NEXT STATE ACCORDINT TO ACTION
    return 0
  }

  public func getReward(state: Int) -> Int {
    //TODO: SETUP REWARDS ACCORDINT TO STATE
    return 0
  }

  private func isTerminalState(state: Int) -> Bool {
    for s in terminal_states {
      if s == state {
        return true
      }
    }
    return false
  }
  
}
