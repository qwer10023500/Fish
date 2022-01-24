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
    
    /** isSelected */
    var isSelected: Bool = false
    
    convenience init(_ name: String, isSelected: Bool = true) {
        self.init()
        self.name = name
        self.isSelected = isSelected
    }
    
    override init() { super.init() }
    
    required init?(coder: NSCoder) {
        super.init()
        name = coder.decodeObject(forKey: "name") as? String ?? String()
        stocks = coder.decodeObject(forKey: "stocks") as? [QHStockModel] ?? [QHStockModel]()
        isSelected = coder.decodeBool(forKey: "isSelected")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(stocks, forKey: "stocks")
        coder.encode(isSelected, forKey: "isSelected")
    }
}

// MARK: Public
extension QHCategoryModel {
    /** to dictionary */
    public func _toDictionary() -> [String : Any] {
        return [
            "name" : name,
            "stocks" : stocks.map({ stock in return stock._toDictionary() }),
            "isSelected" : isSelected
        ]
    }
}
