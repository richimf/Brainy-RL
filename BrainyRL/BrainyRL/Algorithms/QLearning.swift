//
//  QLearning.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

// Q-Learning Algorithm
/***
 Example of use:

 Let’s say that a robot has to cross a maze and reach the end point.
 There are mines, and the robot can only move one tile at a time.
 If the robot steps onto a mine, the robot is dead.
 The robot has to reach the end point in the shortest time possible.
 But the robot loses 1 point at each step. This is done so that the robot takes the shortest path and reaches the goal as fast as possible.
 If robot steps on a mine, the point loss is 100 and the game ends.
 If the robot gets power, it gains 1 point of reward.
 If the robot reaches the end goal the robot gets 100 points.
 */
import Foundation

open class QLearning {
  
  //MARK: - TypeAlias
  public typealias Qvalue = Int
  public typealias Action = Int
  public typealias NextStateAndReward = (next_state: Int, reward: Int, done: Bool, info: String)

  //MARK: - Constants
  private var kColumns: Int = 0
  private var kRows: Int = 0
  
  //MARK: - Parameters
  /// Learning Rate: alpha
  private var alpha: Float = 0.1
  /// Discount Rate: gamma
  private var discount_rate: Float = 0.01
  /// Epsilon
  private var epsilon: Float = 0.1
  private var max_epsilon: Float = 1.0
  private var min_epsilon: Float = 0.01

  //MARK: - Q-Table
  /// The *Q-Table* helps us to find the best action for each state.
  public var QTable = [[Int]]()
  public var actions = [Int]()
  public var states = [Int]()
  
  public var environment: (Int) -> (Int)

  //MARK: - Initializers
  public init(environment: @escaping (Int) -> (Int)) {
    self.environment = environment
  }

  // MARK: - Choose and Perform an Action
  // We have to define when to stop training or if it is undefined amount of time.
  // We will choose an action (a) in the state (s) based on the Q-Table.
  // MARK: - Epsilon Greedy Strategy. Exploitation.
  public func train(until: Int = 1000, train: inout ()->()) {
    var episode: Int = 0
    while episode < until {
      for s in states {
        let a = chooseAction(state: s)
        let env = getNextStateAndReward(action: a)//environment.step(action)
        let next_max = QTable[env.next_state] //todo, get max from qtable
        QTable[env.next_state][a] = QTable
      }
      episode = episode + 1
    }
  }

  private func chooseAction(state: Int) -> Action {
    // pick number between 0 and actions.count - 1
    //let number = Int(arc4random_uniform(UInt32(actions.count)))
    //let action = actions[number]
    //let action = argmax(QTable[state])
    let action = QTable[state].endIndex //TODO NO ES ESTE, SOLO PARA PRUEBAS
    return action
  }

  /// Q-function returns the expected future reward of that action at that state.
  public func Q(_ s: Int, _ a: Int) -> Qvalue {
    let reward = R(s,a)
    //return 0
    // TODO: IMPLEMENT FUNCTION
     q_table[state,action] =  q_table[state,action] + alpha * ( reward + gamma * next_max - q_table[state,action])
    return Q(s,a) + alpha*(reward + getArgMaxwithDiscount() - Q(s,a))
  }
  
  public func getNextStateAndReward(action: Int) -> NextStateAndReward {
    return (next_state: 0, reward: 0, done: true, info: "")
  }

  private func getArgmaxwithDiscount() -> Float {
    return 0.0 //discount_rate * argmax(a: self.QTable)
  }

  private func R(_ s: Int, _ a: Int) -> Int {
    return 0
  }
}

// MARK: - Q-Table
extension QLearning: QtableProtocol {
 
  public func initQTable() {
    self.kColumns = self.actions.count
    self.kRows = self.states.count
    self.QTable = Array(repeating: Array(repeating: 0, count: self.kColumns), count: self.kRows)
  }

  public func clearQtable() {
    self.QTable = [[Int]]()
  }

  public func setValueAt(column: Int, row: Int, value: Int) throws {
    if self.QTable.capacity > 0 {
      if row >= 0 && row < self.kRows && column >= 0 && column < self.kColumns {
        self.QTable[column][row] = value
      } else {
        throw RLError.outofIndex
      }
    } else {
      throw RLError.qtableNotInitialized
    }
  }

  public func getValueAt(column: Int, row: Int) throws -> Int {
    if self.QTable.capacity <= 0 {
      throw RLError.qTableEmpty
    }
    if row >= 0 && row < self.kRows && column >= 0 && column < self.kColumns {
      return self.QTable[column][row]
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
  
  public func setMaximumEpsilon(_ value: Float) {
    self.max_epsilon = value
  }
  
  public func setMinimumEpsilon(_ value: Float) {
    self.min_epsilon = value
  }
}

