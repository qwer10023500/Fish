//
//  QHConfiguration.swift
//  BigStart
//
//  Created by 小孩 on 2021/3/3.
//

import Foundation

struct QHConfiguration {
    /** numberFormatter */
    public static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

func QHLog(_ item: Any, file : String = #file, lineNum : Int = #line) {
    #if DEBUG
    print("\(NSDate()) \((file as NSString).lastPathComponent) line:\(lineNum) \(item)")
    #endif
}

func QHDump(_ item: Any, file : String = #file, lineNum : Int = #line) {
    #if DEBUG
    dump(item, name: "\(NSDate()) \((file as NSString).lastPathComponent) line:\(lineNum)")
    #endif
}
