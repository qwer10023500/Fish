//
//  QHStockTableHeaderViewCell.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

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
        
        contentView.layer.cornerRadius = 10
        
        let gesture = UILongPressGestureRecognizer()
        gesture.rx.event.subscribe(onNext: { [weak self] gesture in
            guard let `self` = self, gesture.state == .began else { return }
            NotificationCenter.default.post(name: NSNotification.Name("longPress.QHStockTableHeaderViewCell"), object: self.category)
        }).disposed(by: rx.disposeBag)
        contentView.addGestureRecognizer(gesture)
    }

}
