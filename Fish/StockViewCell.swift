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
            
            textLabel?.textColor = UIColor.black.withAlphaComponent(0.7)
            switch stock.mode {
            case .other:
                textLabel?.text = String(format: "%@  %@  %@", stock.name, stock.price, stock.fluctuation)
            case .index:
                textLabel?.text = String(format: "%@  %@  %@  %@", stock.name, stock.price, stock.point, stock.fluctuation)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
}
