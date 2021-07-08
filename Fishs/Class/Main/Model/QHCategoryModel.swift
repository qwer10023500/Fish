//
//  QHCategoryModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

class QHCategoryModel: QHBaseModel, NSCoding {

    /** name */
    var name: String = String()
    
    /** stocks */
    var stocks: [QHStockModel] = [QHStockModel]()
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
    
    override init() { super.init() }
    
    required init?(coder: NSCoder) {
        super.init()
        name = coder.decodeObject(forKey: "name") as? String ?? String()
        stocks = coder.decodeObject(forKey: "stocks") as? [QHStockModel] ?? [QHStockModel]()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(stocks, forKey: "stocks")
    }
}
