//
//  QHDetailViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import Kingfisher

class QHDetailViewController: QHBaseViewController {

    public var stock = QHStockModel()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func structureUI() {
        super.structureUI()
        
        kImage()
    }
    
    @IBAction func segmetedControlValueChange(_ sender: UISegmentedControl) {
        kImage()
    }
}

extension QHDetailViewController {
    /** image */
    fileprivate func kImage() {
        let id = stock.id.replacingOccurrences(of: "s_", with: "")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            imageView.kf.setImage(with: URL(string: "https://image.sinajs.cn/newchart/min/n/\(id).gif"), options: [.forceRefresh])
        case 1:
            imageView.kf.setImage(with: URL(string: "https://image.sinajs.cn/newchart/daily/n/\(id).gif"), options: [.forceRefresh])
        case 2:
            imageView.kf.setImage(with: URL(string: "https://image.sinajs.cn/newchart/weekly/n/\(id).gif"), options: [.forceRefresh])
        case 3:
            imageView.kf.setImage(with: URL(string: "https://image.sinajs.cn/newchart/monthly/n/\(id).gif"), options: [.forceRefresh])
        default:
            break
        }
    }
}
