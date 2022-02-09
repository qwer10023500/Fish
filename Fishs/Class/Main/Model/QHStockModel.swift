//
//  QHStockModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

class QHTradeModel: QHBaseModel, NSCoding {
    /** price */
    var price: String = String()
    
    /** count */
    var count: String = String()
    
    convenience init(_ price: String, count: String) {
        self.init()
        self.price = price
        self.count = count
    }
    
    override init() { super.init() }
    
    required init?(coder: NSCoder) {
        super.init()
        price = coder.decodeObject(forKey: "price") as? String ?? String()
        count = coder.decodeObject(forKey: "count") as? String ?? String()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(price, forKey: "price")
        coder.encode(count, forKey: "count")
    }
}

class QHStockModel: QHBaseModel, NSCoding {
    enum Mode: Int {
        case index = 0
        case stock = 1
    }
    
    /** id */
    var id: String = String()
    
    /** mode */
    var mode: QHStockModel.Mode = .stock
    
    /** name */
    var name: String = String()
    
    /** price */
    var price: String = String()
    
    /** % */
    var fluctuation: String = String()
    
    /** point */
    var point: String = String()
    
    /** max */
    var max: String = String()
    
    /** min */
    var min: String = String()
    
    /** start */
    var start: String = String()
    
    /** yesterday */
    var yesterday: String = String()
    
    /** cost */
    var cost: Double = 0
    
    /** count */
    var count: Int = 0
    
    /** buys */
    var buys: [QHTradeModel] = [QHTradeModel]()
    
    /** sells */
    var sells: [QHTradeModel] = [QHTradeModel]()
    
    convenience init(_ id: String,
                     mode: QHStockModel.Mode = .stock,
                     name: String = String(),
                     price: String = String(),
                     fluctuation: String = String(),
                     point: String = String(),
                     max: String = String(),
                     min: String = String(),
                     start: String = String(),
                     yesterday: String = String()) {
        self.init()
        self.id = id
        self.mode = mode
        self.name = name
        self.price = price
        self.fluctuation = fluctuation
        self.point = point
        self.max = max
        self.min = min
        self.start = start
        self.yesterday = yesterday
    }
    
    override init() { super.init() }
    
    required init?(coder: NSCoder) {
        super.init()
        id = coder.decodeObject(forKey: "id") as? String ?? String()
        if let mode = Mode.init(rawValue: coder.decodeInteger(forKey: "mode")) { self.mode = mode }
        name = coder.decodeObject(forKey: "name") as? String ?? String()
        price = coder.decodeObject(forKey: "price") as? String ?? String()
        fluctuation = coder.decodeObject(forKey: "fluctuation") as? String ?? String()
        point = coder.decodeObject(forKey: "point") as? String ?? String()
        max = coder.decodeObject(forKey: "max") as? String ?? String()
        min = coder.decodeObject(forKey: "min") as? String ?? String()
        start = coder.decodeObject(forKey: "start") as? String ?? String()
        yesterday = coder.decodeObject(forKey: "yesterday") as? String ?? String()
        buys = coder.decodeObject(forKey: "buys") as? [QHTradeModel] ?? [QHTradeModel]()
        sells = coder.decodeObject(forKey: "sells") as? [QHTradeModel] ?? [QHTradeModel]()
        cost = coder.decodeDouble(forKey: "cost")
        count = coder.decodeInteger(forKey: "count")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(mode.rawValue, forKey: "mode")
        coder.encode(name, forKey: "name")
        coder.encode(price, forKey: "price")
        coder.encode(fluctuation, forKey: "fluctuation")
        coder.encode(point, forKey: "point")
        coder.encode(max, forKey: "max")
        coder.encode(min, forKey: "min")
        coder.encode(start, forKey: "start")
        coder.encode(yesterday, forKey: "yesterday")
        coder.encode(cost, forKey: "cost")
        coder.encode(count, forKey: "count")
        coder.encode(buys, forKey: "buys")
        coder.encode(sells, forKey: "sells")
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let `object` = object as? QHStockModel else { return false }
        return object.id == id
    }
}

// MARK: Public
extension QHStockModel {
    /** parsing */
    public class func parsing(_ value: String) -> QHStockModel {
        let array = value.replacingOccurrences(of: "v_", with: "").components(separatedBy: "=")
        var stock = QHStockModel()
        guard array.count >= 2 else { return stock }
        let id = array[0]
        let list = array[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ";", with: "").components(separatedBy: "~")
        if id == "sh000001" || id == "sz399006" || id == "sz399001" {
            stock = QHStockModel(id, mode: .index, name: list[1], price: list[3], fluctuation: String(format: "%@%%", list[32]), point: list[31])
        } else {
            stock = QHStockModel(id,
                                 mode: .stock,
                                 name: list[1],
                                 price: list[3],
                                 fluctuation: String(format: "%@%%", list[32]),
                                 point: list[31],
                                 max: list[33],
                                 min: list[34],
                                 start: list[5],
                                 yesterday: list[4]
            )
            stock.buys = [
                QHTradeModel(list[9], count: list[10]),
                QHTradeModel(list[11], count: list[12]),
                QHTradeModel(list[13], count: list[14]),
                QHTradeModel(list[15], count: list[16]),
                QHTradeModel(list[17], count: list[18])
            ]
            stock.sells = [
                QHTradeModel(list[19], count: list[20]),
                QHTradeModel(list[21], count: list[22]),
                QHTradeModel(list[23], count: list[24]),
                QHTradeModel(list[25], count: list[26]),
                QHTradeModel(list[27], count: list[28])
            ]
        }
        return stock
    }
}
