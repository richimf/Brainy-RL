//
//  QLearning.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

open class QLearning {

  //MARK: - TypeAlias
  public typealias Qvalue = Int
  public typealias Action = Int
  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool, info: String)

  //MARK: - Parameters
  private var kRows: Int = 0    //states
  private var kColumns: Int = 0 //actions

  /// Learning Rate: alpha
  private var alpha: Float = 0.1
  /// Discount Rate: gamma
  private var discount_rate: Float = 0.01
  private var learning_rate: Float = 0.7

  /// Epsilon
  private var epsilon: Float = 1.0
  private let max_epsilon: Float = 1.0
  private let min_epsilon: Float = 0.01
  private let decay_rate: Float = 0.01

  //MARK: - Q-Table and Environment
  /// The *Q-Table* helps us to find the best action for each state.
  public var QTable = [[Int]]()
  private var Environment: BranyEnvironment

  //MARK: - Initializers
  public init(environment: BranyEnvironment) {
    self.Environment = environment
  }

  // MARK: - Choose and Perform an Action
  // We have to define when to stop training or if it is undefined amount of time.
  // We will choose an action (a) in the state (s) based on the Q-Table.
  // MARK: - Epsilon Greedy Strategy. Exploitation.
  public func train(steps: Int = 100, episodes: Int = 1000) {

    for episode in 0...episodes {
      var state = 0
      var step = 0
      var done = false
      
      for step in 0...steps {
        //Choose an action a in the current world state (s)
        let action = epsilonGreedy(state: state)
        let (next_state, reward, done, info) = getNextStateAndReward(action: action)

        //Update Q-Table
        //Update Q(s,a) = Q(s,a) + lr [R(s,a) + gamma * maxQ(s',a') - Q(s,a)]
        let Qsa = try? Q(state, action)
        let r = R(state, action)
        //TODO: FINISH THIS:
        let newValue = 0 //Qsa + learning_rate * (r + getArgmaxwithDiscount(state: next_state) - Qsa)
        try? updateQtable(row: state, column: action, value: newValue)
        //update current state
        state = next_state
      }
    }
  }

  /// Q-function returns the expected future reward of that action at that state.
  public func Q(_ s: Int, _ a: Int) throws -> Qvalue {
    if s <= self.kRows && a <= self.kColumns {
      return try! self.getQTableValueAt(row: s, column: a)
    } else {
      throw RLError.outofIndex
    }
  }

  //MARK: - Strategy
  public func epsilonGreedy(state: Int) -> Action {
    var action: Int = 0
    let randomNumber:Float = Float(Float(arc4random()) / Float(UINT32_MAX))
    if randomNumber > epsilon {
      //EXPLOITATION, this means we use what we already know to select the best action at each step
      action = Utils.argmax(table: self.QTable, row: state)
    } else {
      //EXPLORATION
      action = Environment.getRandomAction()
      //Reduce epsilon
      if epsilon > min_epsilon {
        epsilon = epsilon - decay_rate
      }
    }
    return action
  }
  
  public func getNextStateAndReward(action: Int) -> NextStateAndReward {
    //TODO: COMPLETE THIS
    return (next_state: 0, reward: 0, done: true, info: "")
  }

  private func getArgmaxwithDiscount(state: Int) -> Float {
    return discount_rate * Float(Utils.argmax(table: self.QTable, row: state))
  }

  private func R(_ s: Int, _ a: Int) -> Int {
    //TODO: COMPLETE THIS
    return 0
  }
}

// MARK: - Q-Table
extension QLearning: QtableProtocol {
 
  public func initQTable() {
    self.kColumns = self.Environment.actions.count
    self.kRows = self.Environment.states.count
    self.QTable = Array(repeating: Array(repeating: 0, count: self.kColumns), count: self.kRows)
  }

  public func clearQtable() {
    self.QTable = [[Int]]()
  }

  public func updateQtable(row: Int, column: Int, value: Int) throws {
    if self.QTable.capacity > 0 {
      if column >= 0 && column < self.kColumns && row >= 0 && row < self.kRows {
        self.QTable[row][column] = value
      } else {
        throw RLError.outofIndex
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
    self.discount_rate = value
  }
  
  public func setAlpha(_ value: Float) {
    self.alpha = value
  }
  
  public func setEpsilon(_ value: Float) {
    self.epsilon = value
  }
}

// MARK: - Observers
// TODO: IMPLEMENT
// extension QLearning: ObserverProtocol {}




