//
//  Defaults.swift
//  BigStart
//
//  Created by 小孩 on 2020/11/13.
//

import UIKit

class Defaults: NSObject {
    static let shared = Defaults()
    
    fileprivate override init() { super.init() }
    
    /** indexs */
    public var indexs: [QHStockModel] {
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: #function)
        }
        get {
            let array = [QHStockModel("s_sh000001"), QHStockModel("s_sz399001"), QHStockModel("s_sz399006")]
            guard let data = UserDefaults.standard.data(forKey: #function) else {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: #function)
                return array
            }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [QHStockModel] ?? [QHStockModel]()
        }
    }
    
    /** categories */
    public var categories: [QHCategoryModel] {
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: #function)
        }
        get {
            let array = [QHCategoryModel("Own")]
            guard let data = UserDefaults.standard.data(forKey: #function) else {
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: array), forKey: #function)
                return array
            }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [QHCategoryModel] ?? [QHCategoryModel]()
        }
    }
}
