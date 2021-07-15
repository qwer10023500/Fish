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
    
    @IBOutlet weak var countView: UITextField!
    
    @IBOutlet weak var costView: UITextField!
    
    override func structureUI() {
        super.structureUI()
        
        kImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let categories = Defaults.shared.categories
        for category in categories {
            for item in category.stocks {
                guard stock == item else { continue }
                if let text = countView.text, let count = Int(text) { item.count = count }
                if let text = costView.text, let cost = Double(text) { item.cost = cost }
                break
            }
        }
        Defaults.shared.categories = categories
    }
    
    @IBAction func segmetedControlValueChange(_ sender: UISegmentedControl) {
        kImage()
    }
    
    @IBAction func newsAction(_ sender: UIButton) {
        let id = stock.id.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
        let controller = QHDetailWebViewController(URL(string: "http://stockpage.10jqka.com.cn/\(id)"))
        navigationController?.pushViewController(controller, animated: true)
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
