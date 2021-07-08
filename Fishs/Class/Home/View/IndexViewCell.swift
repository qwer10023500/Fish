//
//  IndexViewCell.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

class IndexViewCell: UICollectionViewCell {

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var fluctuationView: UILabel!
    @IBOutlet weak var pointView: UILabel!
    
    public var stock: QHStockModel? {
        didSet {
            guard let `stock` = stock else { return }
            
            nameView.text = stock.name
            
            priceView.text = stock.price
            
            fluctuationView.text = stock.fluctuation
            
            pointView.text = stock.point
            
            for view in contentView.subviews {
                guard let label = view as? UILabel else { continue }
                if stock.point.contains("-") {
                    label.textColor = UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1)
                } else {
                    label.textColor = UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
