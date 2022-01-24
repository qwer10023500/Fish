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
    public var indexs: [QHStockModel] = [QHStockModel("sh000001"), QHStockModel("sz399001"), QHStockModel("sz399006")]
    
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
    
    /** money */
    public var money: String {
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
        get {
            UserDefaults.standard.string(forKey: #function) ?? String()
        }
    }
    
    /** financing */
    public var financing: String {
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
        get {
            UserDefaults.standard.string(forKey: #function) ?? String()
        }
    }
    
    /** trade */
    public var trade: String {
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
        get {
            UserDefaults.standard.string(forKey: #function) ?? String()
        }
    }
    
    /** target */
    public var target: String {
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
        get {
            UserDefaults.standard.string(forKey: #function) ?? String()
        }
    }
}
