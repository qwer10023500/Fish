//
//  QHDetailViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/9.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import SDWebImage

class QHDetailViewController: QHBaseViewController {

    /** viewModel */
    fileprivate let viewModel = QHDetailViewModel()
    
    public var stock = QHStockModel()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var countView: UITextField!
    
    @IBOutlet weak var costView: UITextField!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var detailView: UILabel!
    
    @IBOutlet weak var tradeView: UITableView!
    
    /** dateFormatter */
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    /** trades */
    fileprivate var trades: [QHTradeModel] = [QHTradeModel]()
    
    override func structureUI() {
        super.structureUI()
        
        navigationItem.title = stock.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "News", style: .plain, target: self, action: #selector(QHDetailViewController.newsAction(_:)))
        
        if stock.count != 0 { countView.text = String(stock.count) }
        
        if stock.cost != 0 { costView.text = String(stock.cost) }
        
        kImage()
        
        tradeView.register(R.nib.qhDetailViewCell)
        
        viewModel.output.detail.drive(onNext: { [weak self] stock in
            guard let `self` = self else { return }
            var color = UIColor.black
            if stock.fluctuation.contains("-") {
                color = UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1)
            } else {
                color = UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
            }
            self.detailView.textColor = color
            self.detailView.text = String(format: "今开: %@ 最高: %@ 最低: %@", stock.start, stock.max, stock.min)
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(string: String(format: "%@  %@  %@  ", stock.name, stock.price, stock.fluctuation), attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : color
            ]))
            if let price = Double(stock.price), self.stock.cost != 0 && self.stock.count != 0 {
                let count = Double(self.stock.count)
                attributedText.append(NSAttributedString(string: String(format: "(总盈亏: %@,%.2f%%)", QHConfiguration.numberFormatter.string(from: NSNumber(value: (price - self.stock.cost) * count)) ?? String(), (price / self.stock.cost - 1) * 100), attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                    NSAttributedString.Key.foregroundColor : price <= self.stock.cost ? UIColor(red: 27 / 255.0, green: 180 / 255.0, blue: 134 / 255.0, alpha: 1) : UIColor(red: 241 / 255.0, green: 22 / 255.0, blue: 38 / 255.0, alpha: 1)
                ]))
            }
            self.titleView.attributedText = attributedText
            self.trades = stock.sells.reversed() + stock.buys
            self.tradeView.reloadData()
            self.update()
        }).disposed(by: rx.disposeBag)
        
        viewModel.input.detail.onNext(stock.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let categories = Defaults.shared.categories
        for category in categories {
            for item in category.stocks {
                guard stock == item else { continue }
                if let text = countView.text, let count = Int(text) { item.count = count }
                if let text = costView.text, let cost = Double(text) { item.cost = cost }
            }
        }
        Defaults.shared.categories = categories
    }
    
    @IBAction func segmetedControlValueChange(_ sender: UISegmentedControl) {
        kImage()
    }
    
    @objc fileprivate func newsAction(_ sender: UIBarButtonItem) {
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
            imageView.sd_setImage(with: URL(string: "https://image.sinajs.cn/newchart/min/n/\(id).gif"), placeholderImage: nil, options: .refreshCached)
        case 1:
            imageView.sd_setImage(with: URL(string: "https://image.sinajs.cn/newchart/daily/n/\(id).gif"), placeholderImage: nil, options: .refreshCached)
        case 2:
            imageView.sd_setImage(with: URL(string: "https://image.sinajs.cn/newchart/weekly/n/\(id).gif"), placeholderImage: nil, options: .refreshCached)
        case 3:
            imageView.sd_setImage(with: URL(string: "https://image.sinajs.cn/newchart/monthly/n/\(id).gif"), placeholderImage: nil, options: .refreshCached)
        default:
            break
        }
    }
    
    /** update stock */
    fileprivate func update() {
        guard UIApplication.shared.applicationState == .active else { return }
        guard isTransactionTime(start: "09:30:00", end: "11:30:00") || isTransactionTime(start: "13:00:00", end: "14:57:00") else { return }
        Observable.just(()).delay(.milliseconds(15 * 100), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.viewModel.input.detail.onNext(self.stock.id)
        }).disposed(by: rx.disposeBag)
    }
    
    /** transaction */
    fileprivate func isTransactionTime(start: String, end: String) -> Bool {
        let string = dateFormatter.string(from: Date())
        guard let start = dateFormatter.date(from: start), let end = dateFormatter.date(from: end), let today = dateFormatter.date(from: string) else { return false }
        return today.compare(start) == .orderedDescending && today.compare(end) == .orderedAscending
    }
}

extension QHDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.qhDetailViewCell, for: indexPath) else { return UITableViewCell() }
        cell.trade = trades[indexPath.row]
        return cell
    }
}
