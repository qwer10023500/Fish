//
//  QHDetailViewCell.swift
//  Fishs
//
//  Created by 小孩 on 2022/2/10.
//

import UIKit

class QHDetailViewCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
    
    /** trade */
    public var trade: QHTradeModel? {
        didSet {
            guard let `trade` = trade else { return }
            
            if trade.name.contains("1") {
                titleView.font = UIFont.systemFont(ofSize: 16)
            } else {
                titleView.font = UIFont.systemFont(ofSize: 11)
            }
            titleView.text = String(format: "%@ : %@ (%@)", trade.name, trade.price, trade.count)
        }
    }
    
}
