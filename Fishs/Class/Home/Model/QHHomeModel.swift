//
//  QHHomeModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

class QHHomeModel: QHBaseModel {

    /** indexs */
    public var indexs: [QHStockModel] {
        set {
            Defaults.shared.indexs = newValue
        }
        get {
            return Defaults.shared.indexs
        }
    }
    
    /** categories */
    public var categories: [QHCategoryModel] {
        set {
            Defaults.shared.categories = newValue
        }
        get {
            return Defaults.shared.categories
        }
    }
}
