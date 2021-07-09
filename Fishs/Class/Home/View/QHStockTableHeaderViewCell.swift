//
//  QHStockTableHeaderViewCell.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit

class QHStockTableHeaderViewCell: UICollectionViewCell {

    @IBOutlet weak var nameView: UILabel!
    
    public var category: QHCategoryModel? {
        didSet {
            guard let `category` = category else { return }
            
            nameView.text = category.name
            
            contentView.backgroundColor = category.isSelected ? UIColor.cyan : UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
