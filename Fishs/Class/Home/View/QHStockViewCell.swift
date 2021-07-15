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
            
            if let price = Double(stock.price), let yesterday = Double(stock.yesterday), stock.cost != 0 && stock.count != 0 {
                let count = Double(stock.count)
                let attributedText = NSMutableAttributedString(string: String(format: "当日盈亏: %@",
                                                                              QHConfiguration.numberFormatter.string(from: NSNumber(value: (price - yesterday) * count)) ?? String()), attributes: [
                                                                                NSAttributedString.Key.foregroundColor : yesterday >= price ? UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1) : UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
                                                                              ])
                attributedText.append(NSAttributedString(string: String(format: "\n总盈亏: %@",
                                                                        QHConfiguration.numberFormatter.string(from: NSNumber(value: (price - stock.cost) * count)) ?? String()), attributes: [
                                                                            NSAttributedString.Key.foregroundColor : price <= stock.cost ? UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1) : UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
                                                                        ]))
                incomeView.attributedText = attributedText
            } else {
                incomeView.attributedText = nil
            }
        }
    }
}
