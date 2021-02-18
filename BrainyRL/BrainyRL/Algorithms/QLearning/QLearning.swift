//
//  QLearning.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

open class QLearning {

  // MARK: - TypeAlias
  public typealias Qvalue = Int
  public typealias Action = Int
  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool)

  // MARK: - Parameters
  private var kRows: Int = 0    // states
  private var kColumns: Int = 0 // actions

  /// Learning Rate: alpha
  private var alpha: Float = 0.1

  /// Discount Rate: gamma
  private var discountRate: Float = 0.01 // this
  private var learningRate: Float = 0.7 // this

  /// Epsilon
  private var epsilon: Float = 0.5 // this
  private let maxEpsilon: Float = 1.0
  private let minEpsilon: Float = 0.01
  private let decayRate: Float = 0.01

  // MARK: - Q-Table
  /// The *Q-Table* helps us to find the best action for each state.
  public var QTable = [[Int]]() // this
  public var actions = [Int]() // this
  private let defaultAction: Int = 0
  private var observation: Int = 0
  public var isDone: Bool = false

  /// We have to define when to stop training or if it is undefined amount of time.
  /// We will choose an action (a) in the state (s) based on the Q-Table.
//  public func train(steps: Int, episodes: Int, terminalState: Int, nextStateAndReward: (_ action: Int) throws -> NextStateAndReward) {
//    for _ in 0...episodes {
//
//      var observation = 0 //Observation
//
//      for _ in 0...steps {
//        //Choose an action a in the current world state (s)
//        let action = chooseAction(state: observation)
//        let (next_state, reward, done) = try! nextStateAndReward(action)
//
//        //LEARN
//        //Update Q(s,a) = Q(s,a) + lr [R(s,a) + gamma * maxQ(s',a') - Q(s,a)]
//        try! updateQtable(row: action, column: observation, value: next_state)
//        let q_predict: Float = try! Float(Q(observation, action)) // QSA
//        let R = Float(reward)
//        var q_target: Float = 0.0
//
//        if next_state != terminalState {
//          //q_target = r + gamma*max_a[Q(S',a)]
//          //q_target = r + self.gamma * self.q_table.loc[s_, :].max()  # next state is not terminal
//          q_target = R + discount_rate * getArgmax(state: next_state)
//
//        } else {
//          q_target = R
//          // Q(S,A) <- Q(S,A) + alfa[r + gamma*max_aQ(S',a) - Q(S,A)]
//          // Q(S,A) <- Q(S,A) + alfa[q_target - Q(S,A)]  # alfa is the learning rate: "self.lr"
//          // Q(S,A) <- Q(S,A) + self.lr * (q_target - q_predict)
//        }
//        let _QSA: Float = alpha*(q_target - q_predict)
//        let newValue = q_predict + learning_rate * _QSA
//        try? updateQtable(row: observation, column: action, value: Int(newValue))
//
//        //update current state
//        if next_state < self.kRows {
//          observation = next_state
//        }
//        if done {
//          break
//        }
//      }
//    }
//  }

  // EXPERIMENTAL
  public func train(terminalState: Int, nextStateAndReward: (_ action: Int) throws -> NextStateAndReward) {

    if isDone == false {
      
      // Choose an action a in the current world state (s)
      let action = chooseAction(state: observation)
      
      // Environment step, game do this nextStateAndReward
      let (next_state, reward, done) = try! nextStateAndReward(action)
      
      // Notify isDone
      isDone = done
      
      // LEARN
      learn(state: observation,
            action: action,
            next_state: next_state,
            reward: reward,
            terminalState: terminalState) // TODO: SET TERMINAL STATE
      
      // update current state
      if next_state < self.kRows {
        observation = next_state
      }
    }
  }

  private func learn(state: Int, action: Int, next_state: Int, reward: Int, terminalState: Int) {
    // Update Q(s,a) = Q(s,a) + lr [R(s,a) + gamma * maxQ(s',a') - Q(s,a)]
    let q_predict: Float = try! Float(Q(state, action)) // QSA
    let R = Float(reward)
    var q_target: Float = 0.0
    if next_state != terminalState {
      // q_target = r + gamma*max_a[Q(S',a)]
      // q_target = r + self.gamma * self.q_table.loc[s_, :].max()  # next state is not terminal
      q_target = R + discountRate * getArgmax(state: next_state)
    } else {
      q_target = R
      // Q(S,A) <- Q(S,A) + alfa[r + gamma*max_aQ(S',a) - Q(S,A)]
      // Q(S,A) <- Q(S,A) + alfa[q_target - Q(S,A)]  # alfa is the learning rate: "self.lr"
      // Q(S,A) <- Q(S,A) + self.lr * (q_target - q_predict)
    }
    let _QSA: Float = alpha*(q_target - q_predict)
    let newValue = q_predict + learningRate * _QSA
    try? updateQtable(row: state, column: action, value: Int(newValue))
  }

  /// Q-function returns the expected future reward of that action at that state.
  public func Q(_ s: Int, _ a: Int) throws -> Qvalue {
    if s < self.kRows && a < self.kColumns {
      return try! self.getQTableValueAt(row: s, column: a)
    } else {
      throw RLError.outofIndex
    }
  }

  // MARK: - CHOOSE ACTION
  /// Epsilon Greedy is the strategy to follow in two flavors: Exploitation and Exploration
  public func chooseAction(state: Int) -> Action {
    var action: Action = 1 // DEFAULT VALUE
    let randomNumber: Float = Float(Float(arc4random()) / Float(UINT32_MAX))
    if randomNumber < epsilon {
      // CHOOSE BEST ACTION
      action = Utils.getActionIndex(table: QTable, row: state)
    } else {
      // CHOOSE RANDOM ACTION
      let randomNumber = Int(arc4random_uniform(UInt32(self.kColumns))) // kColumns is number of actions
      action = actions[randomNumber]
    }
    // Reduce epsilon
    if epsilon > minEpsilon {
      epsilon -= decayRate
    }
    return action
  }

  // This returns an
  private func getArgmax(state: Int) -> Float {
    return Float(Utils.getActionIndex(table: self.QTable, row: state))
  }

}

// MARK: - Q-Table
extension QLearning: QtableProtocol {

  /// Actions Space **actions_space** and **states_number** are provided by the **Environment**.
  public func initQTable(actionsSpace: [Int], statesNumber: Int) {
    self.kColumns = actionsSpace.count
    self.actions = actionsSpace
    self.kRows = statesNumber
    self.QTable = Array(repeating: Array(repeating: 0, count: self.kColumns), count: self.kRows)
  }

  public func clearQtable() {
    self.QTable = [[Int]]()
  }

  public func updateQtable(row: Int, column: Int, value: Int) throws {
    if self.QTable.capacity > 0 {
      if column >= 0 && column < self.kColumns && row >= 0 && row < self.kRows {
        self.QTable[row][column] = value
      }
    } else {
      throw RLError.qtableNotInitialized
    }
  }

  public func getQTableValueAt(row: Int, column: Int) throws -> Int {
    if self.QTable.capacity <= 0 {
      throw RLError.qTableEmpty
    }
    if row >= 0 && row < self.kRows && column >= 0 && column < self.kColumns {
      return self.QTable[row][column]
    } else {
      throw RLError.outofIndex
    }
  }
}

// MARK: - Setters
extension QLearning: SettersProtocol {
  public func setDiscountRate(_ value: Float) {
    self.discountRate = value
  }
  
  public func setAlpha(_ value: Float) {
    self.alpha = value
  }
  
  public func setEpsilon(_ value: Float) {
    self.epsilon = value
  }
}
