//
//  Helpers.swift
//  Sokaban
//
//  Created by Nurseit Akysh on 11/14/20.
//

import Foundation

class Helpers {
    
    internal static func parserTextFrom(content:String) -> [[Int]] {
        let sortContent = content.filter { $0.isNumber || $0.isNewline }.split(separator: "\n")
        
        var result:[[Int]] = []
        var arr:[Int] = []

        for value in sortContent{
            value.forEach { (item) in
                arr.append(item.wholeNumberValue!)
            }
            
            result.append(arr)
            arr.removeAll()
        }
        
        return result
        
    }
}
