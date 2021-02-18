//
//  Utils.swift
//  BrainyRL
//
//  Created by Ricardo Montesinos Fernandez on 12/4/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import Foundation

public class Utils {

  /**
   Get max value of a 2D-Matrix
  - Parameters:
      - table: A two dimensional matrix. Its elements should be of the same kind.

   # How to use:
        m = [[77,2,3],[4,5,6]]
        argmax(table: m)
  */
  public class func argmax<T: Comparable>(table: [[T]]) -> T? {
    var map: [T] = [T]()
    let tableCapacityRows = table.capacity
    for tableRow in 0..<tableCapacityRows {
      let columns = table[tableRow].count
      for column in 0..<columns {
        map.append(table[tableRow][column])
      }
    }
    return getLastElementOf(table: map)
  }

  /**
   Get max value index of a given row number in an table
   
  - Parameters:
       - row: row position number
       - table: A two dimensional matrix. Its elements should be of the same kind.

   # How to use:
        let m = [[77,2,3],[4,5,6]]
   getActionIndex(table: m, row: 1)
   */
  public class func getActionIndex<T: Comparable>(table: [[T]], row: Int) -> Int {
    var map: [T] = [T]()
    if row >= 0 && row < table.count {
      let columns = table[row].count // an array of columns
      for column in 0..<columns {
        map.append(table[row][column])
      }
    }
    return getActionIndex(table: map)
  }

  // MARK: - PRIVATE METHODS
  private static func getActionIndex<T: Comparable>(table: [T]) -> Int {
    let size: Int = table.count
    var actionIndex: Int = 0
    if size == 0 {
      return actionIndex
    }
    for index in 0..<size {
      if index == size-1 {
        return actionIndex
      }
      if table[actionIndex] < table[index] {
        actionIndex = index
      }
    }
    return actionIndex
  }

  private static func getLastElementOf<T: Comparable>(table: [T]) -> T? {
    let tableSorted = quicksort(table)
    if tableSorted.isEmpty {
      return nil
    }
    let lastIndex = tableSorted.count - 1
    return tableSorted[lastIndex]
  }

  private static func quicksort<T: Comparable>(_ value: [T]) -> [T] {
    guard value.count > 1 else { return value }
    let pivot = value[value.count/2]
    let less = value.filter { $0 < pivot }
    let equal = value.filter { $0 == pivot }
    let greater = value.filter { $0 > pivot }
    return quicksort(less) + equal + quicksort(greater)
  }
}
