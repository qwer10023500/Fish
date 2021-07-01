//
//  DetailViewController.swift
//  Fish
//
//  Created by 小孩 on 2021/7/1.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    public var stock = Stock()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gifImage()
    }
    
    @IBAction func segmentedControlvalueChange(_ sender: UISegmentedControl) {
        gifImage()
    }
}

// MARK: Private
extension DetailViewController {
    /** image */
    fileprivate func gifImage() {
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
