//
//  Brain.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 11/21/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

open class Brainy: NSObject, BrainProtocol {

  // Brain inputs
  open var environment: BrainyEnvironment?
  private var qLearning = QLearning()   // TODO: Cambia esto a Algoritmo, y que conforme un protocolo

  /**
   This function enables the Agent to think.
   How to: Once Brainy is initialized, and an Environment is setup, use it.
   - Parameters:
      - steps: Number of steps to perform learning, 100 by default.
      - episodes: Number of episodes for learning, 1000 by default.
   
   # How to use:
        let brain = Brainy()
        func someFunction() {
          brain.think()
        }
   */
  open func think(steps: Int = 100, episodes: Int = 1000) throws {
    guard let env = self.environment else { throw RLError.noEnvironment }
    qLearning.initQTable(actions_space: env.action_space.count, states_number: env.states.count)
    qLearning.actions = env.action_space
    qLearning.train(steps: steps, episodes: episodes, nextStateAndReward: env.nextStep)
  }

  open func forget() {
    qLearning.clearQtable()
  }
}


