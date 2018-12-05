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
  public class func argmax<T: Comparable>(table: [[T]]) -> T {
    var map: [T] = [T]()
    let row = table.capacity
    for r in 0..<row {
      let columns = table[r].count
      for c in 0..<columns {
        map.append(table[r][c])
      }
    }
    return getLastElementOf(table: map)
  }
  
  public class func argmax<T: Comparable>(table: [[T]], row: T) -> T {
    var map: [T] = [T]()
    let row = table.capacity
    let columns = table[row].count
    for c in 0..<columns {
      map.append(table[row][c])
    }
    return getLastElementOf(table: map)
  }

  // MARK: - PRIVATE METHODS
  private static func getLastElementOf<T: Comparable>(table: [T]) -> T{
    let tableSorted = quicksort(table)
    let lastIndex = tableSorted.count - 1
    return tableSorted[lastIndex]
  }

  private static func quicksort<T: Comparable>(_ a: [T]) -> [T] {
    guard a.count > 1 else { return a }
    let pivot = a[a.count/2]
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    return quicksort(less) + equal + quicksort(greater)
  }
}
