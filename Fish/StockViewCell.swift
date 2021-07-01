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
            
            detailTextLabel?.textColor = UIColor.black.withAlphaComponent(0.7)
            switch stock.mode {
            case .other:
                textLabel?.text = String(format: "%@  %@  %@", stock.name, stock.price, stock.fluctuation)
                detailTextLabel?.text = String(format: "max: %@ min: %@", stock.max, stock.min)
            case .index:
                textLabel?.text = String(format: "%@  %@  %@  %@", stock.name, stock.price, stock.point, stock.fluctuation)
                detailTextLabel?.text = nil
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        textLabel?.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
        
        textLabel?.textColor = UIColor.black.withAlphaComponent(0.7)
    }
}
