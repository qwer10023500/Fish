//
//  QHHomeViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class QHHomeViewController: QHBaseViewController {
    
    /** viewModel */
    fileprivate let viewModel = QHHomeViewModel()
    
    /** index */
    @IBOutlet weak var indexView: UICollectionView!
    
    /** stock */
    @IBOutlet weak var stockView: UITableView!
    
    override func structureUI() {
        super.structureUI()
        
        viewModel.output.stocks.drive(onNext: { stocks in
            QHDump(stocks)
        }).disposed(by: rx.disposeBag)
        
        viewModel.input.stocks.onNext(Defaults.shared.stocks.map({ stock -> String in return stock.id }))
    }
}

// MARK: Network
extension QHHomeViewController {
    
}
