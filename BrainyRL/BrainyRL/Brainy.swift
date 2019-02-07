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

  open func setup() throws {
    guard let env = self.environment else { throw RLError.noEnvironment }
    qLearning.initQTable(actions_space: env.action_space.count, states_number: env.states.count)
    qLearning.actions = env.action_space
  }

  open func think(steps: Int = 100, episodes: Int = 1000) throws {
    guard let env = self.environment else { throw RLError.noEnvironment }
    qLearning.train(steps: steps, episodes: episodes, nextStateAndReward: env.nextStep)
  }

  open func forget() {
    qLearning.clearQtable()
  }
}


