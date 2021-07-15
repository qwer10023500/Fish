//
//  QHStockViewCell.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit

class QHStockViewCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var detailView: UILabel!
    
    @IBOutlet weak var incomeView: UILabel!
    
    public var stock: QHStockModel? {
        didSet {
            guard let `stock` = stock else { return }
            
            titleView.text = String(format: "%@  %@  %@", stock.name, stock.price, stock.fluctuation)
            detailView.text = String(format: "今开: %@ 最高: %@ 最低: %@", stock.start, stock.max, stock.min)
            if stock.fluctuation.contains("-") {
                titleView.textColor = UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1)
            } else {
                titleView.textColor = UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
            }
            detailView.textColor = titleView.textColor
            
            if let price = Double(stock.price), stock.cost != 0 && stock.count != 0 {
                incomeView.text = QHConfiguration.numberFormatter.string(from: NSNumber(value: (price - stock.cost) * Double(stock.count)))
                
                if incomeView.text?.contains("-") == true {
                    incomeView.textColor = UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1)
                } else {
                    incomeView.textColor = UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
                }
            } else {
                incomeView.text = nil
            }
        }
    }
}
