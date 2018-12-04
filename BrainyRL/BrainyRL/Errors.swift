//
//  Errors.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

enum RLError: String, Error {
  case qTableEmpty = "Q-Table is Empty"
  case outofIndex = "Index not found, verify it."
  case qtableNotInitialized = "Q-Table not initialized."
}
