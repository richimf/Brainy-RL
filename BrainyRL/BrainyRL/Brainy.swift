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
  private var environment: BrainyEnvironment?
  private var qLearning = QLearning()   // Cambia esto a Algoritmo, y que conforme un protocolo

  open func setupEnvironment(numberOfStates: Int, actionSpace: [Int], terminalState: Int) {
    self.environment = BrainyEnvironment(numberOfStates: numberOfStates,
                                         action_space: actionSpace,
                                         terminalState: terminalState)
  }

  open func setupEnvironmentActions(whereToMove: @escaping (_ action: Int) -> Int,
                                    getReward: @escaping(_ state: Int) -> Int,
                                    isTerminalState: @escaping(_ state: Int) -> Bool) throws {

    guard let env = self.environment else { throw RLError.noEnvironment }
    env.whereToMove = whereToMove
    env.getReward = getReward
    env.isTerminalState = isTerminalState
  }

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
  open func think() throws {
    guard let env = self.environment else { throw RLError.noEnvironment }
    qLearning.initQTable(actionsSpace: env.action_space, statesNumber: env.numberOfStates)
    qLearning.train(terminalState: env.terminalState, nextStateAndReward: env.nextStep)
  }

  open func updateQtable(row: Int, column: Int, value: Int) throws {
   try? qLearning.updateQtable(row: row, column: column, value: value)
  }

  /// Brain will forget
  open func forget() {
    qLearning.clearQtable()
  }
}
