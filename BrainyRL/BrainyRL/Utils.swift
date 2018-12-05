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
public class Utils {
 
  public func argmax<T: Comparable>(table: [[T]], row: Int, column: Int ) -> T {
    print(table)
    var map: [T] = [T]()
    for column in 0..<5 {
      map.append(table[row][column])
    }
    print(map)
    let tableSorted = quicksort(map)
    print(tableSorted)
    return tableSorted[0]
  }

//  public static func argmax<T>(table: [[T]], state: Int) throws -> T {
//    if state >= 0 && state < table.count {
//      return table { $0 > $1 }
//    } else {
//      throw RLError.outofIndex
//    }
//  }
  
  private func quicksort<T: Comparable>(_ a: [T]) -> [T] {
    guard a.count > 1 else { return a }
    
    let pivot = a[a.count/2]
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    
    return quicksort(less) + equal + quicksort(greater)
  }
}
//
//public func argmax<T>(a:[T], axis: Int? = nil, out:[T]? = nil) -> T {
//  return T as! T
//}
