//
//  Utils.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

/**
 Returns the indices of the maximum values along an axis.

 - Parameters:
    - a : **array_like**
        Input array.
 
    - axis : **int**, optional
           By default, the index is into the flattened array, otherwise along the specified axis.

 
 - Returns:
    - index_array : ndarray of ints
 */
public func argmax<T>(a: [T]) -> [T] {
  return [] //TODO: IMPLEMENT
}
public func argmax<T>(a: [T], at row: Int) throws -> T {
  if row >= 0 && row < a.count {
    //TODO: IMPLEMENT
    return a[row]
  } else {
    throw RLError.outofIndex
  }
}
//
//public func argmax<T>(a:[T], axis: Int? = nil, out:[T]? = nil) -> T {
//  return T as! T
//}
