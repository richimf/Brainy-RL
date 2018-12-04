//
//  SettersProtocol.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

protocol SettersProtocol {
  /// Discount Rate *gamma*
  func setDiscountRate(_ value: Float)
  /// Learning Rate *alpha*
  func setAlpha(_ value: Float)
  func setEpsilon(_ value: Float)
  func setMaximumEpsilon(_ value: Float)
  func setMinimumEpsilon(_ value: Float)
}

protocol QtableProtocol {
  /** Once Q-Table is initialized, it is filled with Zeros.
   There are **n** columns, where **n =** number of actions.
   There are **m** rows, where **m =** number of states. */
  func initQTable()
  /// Clear the Q-Table
  func clearQtable()
  /// Set a value at given position into Q-Table
  func setValueAt(column: Int, row: Int, value: Int) throws
  func getValueAt(column: Int, row: Int) throws -> Int
}
