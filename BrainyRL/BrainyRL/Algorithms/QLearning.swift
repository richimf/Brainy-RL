//
//  QLearning.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

// Q-Learning Algorithm
/*
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

  //MARK: - Constants
  private var kColumns: Int = 0
  private var kRows: Int = 0
  
  //MARK: - Parameters
  private var gamma: Float = 0.9
  private var alpha: Float = 0.1
  private var epsilon: Float = 0.1
  private var max_epsilon: Float = 1.0
  private var min_epsilon: Float = 0.01
  private var discount_rate: Float = 0.01

  //MARK: - Q-Table
  public var qTable = [[Int]]()

  //MARK: - Initializers
  /// There are **n** columns, where **n =** number of actions.
  /// There are **m** rows, where **m =** number of states.
  public init(numberOfActions: Int, numberOfStates: Int) {
    self.kColumns = numberOfActions
    self.kRows = numberOfStates
  }
  
  // MARK: - Setters
  public func setGamma(_ value: Float) {
    self.gamma = value
  }
  
  /// Learning rate *alpha*
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
  
  public func setDiscountRate(_ value: Float) {
    self.discount_rate = value
  }

  // MARK: - Q-table Methods
  /// Once Q-Table is initialized, it is filled with Zeros.
  public func initQTable() {
    self.qTable = Array(repeating: Array(repeating: 0, count: self.kColumns), count: self.kRows)
  }

  public func clearQtable() {
    self.qTable = [[Int]]()
  }

  /// Set a value at given position into Q-Table
  public func setValueAt(column: Int, row: Int, value: Int) throws {
    if self.qTable.capacity > 0 {
      if row >= 0 && row < self.kRows && column >= 0 && column < self.kColumns {
        self.qTable[column][row] = value
      } else {
        throw RLError.outofIndex
      }
    } else {
      throw RLError.qtableNotInitialized
    }
  }

  public func getValueAt(column: Int, row: Int) throws -> Int {
    if self.qTable.capacity <= 0 {
      throw RLError.qTableEmpty
    }
    if row >= 0 && row < self.kRows && column >= 0 && column < self.kColumns {
      return self.qTable[column][row]
    } else {
      throw RLError.outofIndex
    }
  }

  // MARK: - Choose and Perform an Action
  // We have to define when to stop training or if it is undefined amount of time.
  // We will choose an action (a) in the state (s) based on the Q-Table.
  
  // MARK: - Epsilon Greedy Strategy. Exploitation.
  public func train(until: Int = 10000, train: inout ()->()) {
    var counter: Int = 0
    while counter < until {
      //TODO: SET TRAINING FUNCTION
      counter = counter + 1
    }
  }
  
  /// Q function, Q(state, action)
  public func Q(_ s: Int, _ a: Int) -> Int {
    let reward = R(s,a)
    return 0
    // TODO: IMPLEMENT FUNCTION
    //return Q(s,a) + alpha*(reward + discount_rate*argmax(a: self.qTable) - Q(s,a))
  }
  
  private func R(_ s: Int, _ a: Int) -> Int {
    return 0
  }


}









