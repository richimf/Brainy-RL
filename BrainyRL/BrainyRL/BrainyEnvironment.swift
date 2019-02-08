//
//  Environment.swift
//  BrainyRL
//
//  Created by Richie on 2/6/19.
//  Copyright © 2019 CubitStudio. All rights reserved.
//

import Foundation

// THIS IS A MODEL OF THE ENVIRONMENT

open class BrainyEnvironment {

  public var action_space = [Int]()
  public var states = [Int]()
  public var terminalState: Int

  //Functions given by the Agent
  public var whereToMove: Any = ()
  public var getReward: Any = ()
  public var isTerminalState: Any = ()

  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool)
  public typealias WhereToMove = (_ action: Int) -> Int
  public typealias GetReward = (_ state: Int) -> Int
  public typealias IsTerminalState = (_ state: Int) -> Bool

  init(actionSpace: [Int], states: [Int], terminalState: Int) {
    self.action_space = actionSpace
    self.states = states
    self.terminalState = terminalState
  }

//  public func getRandomAction() -> Int {
//    let number = Int(arc4random_uniform(UInt32(action_space.count-1)))
//    return action_space[number]
//  }
  
  /// Take cction and get next observation and Reward:
  /// THIS FUNCTION TELLS THE AGENT WHERE TO MOVE NEXT
  public func nextStep(action: Int) throws -> NextStateAndReward {

    guard let step = whereToMove as? WhereToMove,
      let getReward = getReward as? GetReward,
      let isTerminalState = isTerminalState as? IsTerminalState else {
        throw RLError.functionsNotInitialized
    }
    let next_state = step(action)
    let reward = getReward(next_state)
    let isDone = isTerminalState(next_state)
    return (next_state: next_state, reward: reward, done: isDone)
  }
}
