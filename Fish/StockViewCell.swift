//
//  StockViewCell.swift
//  Fish
//
//  Created by 小孩 on 2021/6/30.
//

import UIKit

class StockViewCell: UITableViewCell {

    public var stock: Stock? {
        didSet {
            guard let `stock` = stock else { return }
            
            textLabel?.text = String(format: "%@  %@  %@", stock.name, stock.price, stock.fluctuation)
            detailTextLabel?.text = String(format: "今开: %@ 最高: %@ 最低: %@", stock.start, stock.max, stock.min)
            if stock.fluctuation.contains("-") {
                textLabel?.textColor = UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1)
            } else {
                textLabel?.textColor = UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
            }
            detailTextLabel?.textColor = textLabel?.textColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
}
