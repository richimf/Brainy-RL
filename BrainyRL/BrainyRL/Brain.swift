//
//  Brain.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 11/21/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import UIKit

open class Brain: NSObject {

  private let environment = BranyEnvironment()
  //Algorithm
  private var qLearning: QLearning?

  /// states, if penalty state set it with negative value, like so: -1, otherwise set it positive
  public func setup(actions: [Int], states: [Int], maximumReward: Int){
    environment.action_space = actions
    environment.states = states
    environment.maximum_reward = maximumReward
    qLearning = QLearning(environment)
    qLearning?.initQTable()
  }

  public func setPenaltyStates(states: [Int]) {
    environment.penalty_states = states
  }

  public func think(steps: Int = 100, episodes: Int = 1000) {
    qLearning?.train(steps: steps, episodes: episodes)
  }

  public func forget() {
    qLearning?.clearQtable()
  }
}
