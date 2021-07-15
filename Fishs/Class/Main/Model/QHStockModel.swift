//
//  QHStockModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

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
        cost = coder.decodeDouble(forKey: "cost")
        count = coder.decodeInteger(forKey: "count")
        yesterday = coder.decodeObject(forKey: "yesterday") as? String ?? String()
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
        coder.encode(cost, forKey: "cost")
        coder.encode(count, forKey: "count")
        coder.encode(yesterday, forKey: "yesterday")
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
        let array = value.replacingOccurrences(of: "var hq_str_", with: "").replacingOccurrences(of: "\"", with: "").components(separatedBy: "=")
        var stock = QHStockModel()
        guard array.count == 2 else { return stock }
        let id = array[0]
        if id.contains("s_s") {
            let list = array[1].components(separatedBy: ",")
            guard list.count >= 4 else { return stock }
            stock = QHStockModel(id, mode: .index, name: list[0], price: list[1], fluctuation: String(format: "%@%%", list[3]), point: list[2])
            return stock
        } else {
            let list = array[1].components(separatedBy: ",")
            guard list.count >= 6 else { return stock }
            let yesterday: Double = NSString(string: list[2]).doubleValue
            let current: Double = NSString(string: list[3]).doubleValue
            let difference = abs(current - yesterday)
            var symbol = String()
            if current >= yesterday {
                symbol = "+"
            } else {
                symbol = "-"
            }
            stock = QHStockModel(id,
                          mode: .stock,
                          name: list[0],
                          price: current == 0 ? list[2] : list[3],
                          fluctuation: current == 0 ? "0%" : String(format: "%@%.2f%%", symbol, difference / yesterday * 100.0),
                          max: list[4],
                          min: list[5],
                          start: list[1],
                          yesterday: list[2])
            return stock
        }
    }
}
