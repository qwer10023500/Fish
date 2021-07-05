//
//  ViewController.swift
//  Fish
//
//  Created by 小孩 on 2021/6/29.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Alamofire
import MJRefresh

class ViewController: UITableViewController {
    
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate lazy var session: Session = {
        let session = Session.default
        return session
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    /** stocks */
    fileprivate var stocks: [Stock] {
        set {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: #function)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: #function), let values = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Stock] else { return [Stock]() }
            return values
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stocks.count == 0 { stocks = [Stock("s_sh000001"), Stock("s_sz399001"), Stock("s_sz399006")] }
        
        realTime()
        
        tableView.separatorStyle = .singleLineEtched
        tableView.register(StockViewCell.self, forCellReuseIdentifier: NSStringFromClass(StockViewCell.classForCoder()))
        
        MJRefreshNormalHeader { [weak self] in
            guard let `self` = self else { return }
            self.disposeBag = DisposeBag()
            self.realTime()
        }.autoChangeTransparency(true)
        .link(to: tableView)
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
            guard let `self` = self else { return }
            self.realTime()
        }
    }
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Securities code", message: nil, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "code"
            textField.keyboardType = .numberPad
        }
        let alertAction = UIAlertAction(title: "Done", style: .default, handler: { [weak controller] _ in
            guard let `controller` = controller, let text = controller.textFields?.first?.text else { return }
            var string = text
            if text.hasPrefix("6") {
                string = "sh\(text)"
            } else if text.hasPrefix("0") || text.hasPrefix("3") || text.hasPrefix("1") {
                string = "sz\(text)"
            }
            self.check(string)
        })
        if let textField = controller.textFields?.first {
            textField.rx.text.orEmpty.map { (text) -> Bool in
                return text.count >= 6
            }.share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { (event) in
                guard let text = textField.text, event == true else { return }
                textField.text = String(text[text.startIndex...text.index(text.startIndex, offsetBy: 5)])
            }).disposed(by: rx.disposeBag)
            
            textField.rx.text.orEmpty.map { text -> Bool in
                return text.count >= 6 && (text.hasPrefix("6") || text.hasPrefix("0") || text.hasPrefix("3") || text.hasPrefix("1"))
            }.bind(to: alertAction.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        }
        controller.addAction(alertAction)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController {
    /** transaction */
    fileprivate func isTransactionTime(start: String, end: String) -> Bool {
        let string = dateFormatter.string(from: Date())
        guard let start = dateFormatter.date(from: start), let end = dateFormatter.date(from: end), let today = dateFormatter.date(from: string) else { return false }
        return today.compare(start) == .orderedDescending && today.compare(end) == .orderedAscending
    }
}

// MARK: UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(StockViewCell.classForCoder()), for: indexPath) as! StockViewCell
        cell.stock = stocks[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.stock = stocks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            var stocks = self.stocks
            stocks.remove(at: indexPath.row)
            self.stocks = stocks
            tableView.reloadData()
        }
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return stocks[indexPath.row].mode == .index ? 50 : 60
    }
}

// MARK: Network
extension ViewController {
    /** check */
    fileprivate func check(_ id: String) {
        guard !stocks.contains(Stock(id)), let url = URL(string: "https://hq.sinajs.cn/list=\(id)") else { return }
        session.request(url, method: .get)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let cfEncoding = CFStringEncodings.GB_18030_2000
                    let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                    guard let value = NSString(data: data, encoding: encoding) else { return }
                    var stocks = self.stocks
                    stocks.append(Stock.parsing(value: value as String))
                    self.stocks = stocks
                    self.tableView.reloadData()
                case .failure(let error):
                    print(url, error)
                }
            })
    }
    
    /** real time */
    fileprivate func realTime() {
        guard stocks.count != 0 else { return }
        var ids = [String]()
        for item in stocks { ids.append(item.id) }
        guard let url = URL(string: "https://hq.sinajs.cn/list=\(ids.joined(separator: ","))") else { return }
        session.request(url, method: .get)
            .responseData(completionHandler: { response in
                self.tableView.mj_header?.endRefreshing()
                switch response.result {
                case .success(let data):
                    let cfEncoding = CFStringEncodings.GB_18030_2000
                    let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                    guard let value = NSString(data: data, encoding: encoding) else { return }
                    var stocks = [Stock]()
                    for item in value.components(separatedBy: "\n") {
                        guard item.count != 0 else { continue }
                        let stock = Stock.parsing(value: item)
                        stocks.append(stock)
                    }
                    self.stocks = stocks
                    self.tableView.reloadData()
                case .failure(let error):
                    print(url, error)
                }
                guard UIApplication.shared.applicationState == .active else { return }
                guard self.isTransactionTime(start: "09:30", end: "11:30") || self.isTransactionTime(start: "13:00", end: "15:00") else { return }
                Observable.just(()).delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.realTime()
                }).disposed(by: self.disposeBag)
            })
    }
}
