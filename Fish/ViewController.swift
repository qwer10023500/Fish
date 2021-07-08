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

class IndexViewCell: UICollectionViewCell {
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var pointView: UILabel!
    @IBOutlet weak var fluctuationView: UILabel!
    @IBOutlet weak var percentageView: UILabel!
    
    public var stock: Stock? {
        didSet {
            guard let stock = `stock` else { return }
            
            nameView.text = stock.name
            
            pointView.text = stock.price
            
            fluctuationView.text = stock.point
            
            percentageView.text = stock.fluctuation
            
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
}

class ViewController: UIViewController {
    
    fileprivate var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    /** indexs */
    fileprivate var indexs: [Stock] {
        get {
            return stocks.filter { stock in return stock.mode == .index }
        }
    }
    
    /** tickets */
    fileprivate var tickets: [Stock] {
        get {
            return stocks.filter { stock in return stock.mode == .other }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stocks.count == 0 { stocks = [Stock("s_sh000001"), Stock("s_sz399001"), Stock("s_sz399006")] }
        
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
        
        realTime()
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
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
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

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexViewCell", for: indexPath) as! IndexViewCell
        cell.stock = indexs[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.stock = indexs[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(StockViewCell.classForCoder()), for: indexPath) as! StockViewCell
        cell.stock = tickets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        var array = tickets
        array.remove(at: indexPath.row)
        stocks = indexs + array
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var array = tickets
        let item = array[sourceIndexPath.row]
        array.remove(at: sourceIndexPath.row)
        array.insert(item, at: destinationIndexPath.row)
        stocks = indexs + array
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.stock = tickets[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
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
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                case .failure(let error):
                    print(url, error)
                }
                guard UIApplication.shared.applicationState == .active else { return }
                guard self.isTransactionTime(start: "09:30", end: "11:30") || self.isTransactionTime(start: "13:00", end: "15:00") else { return }
                Observable.just(()).delay(.milliseconds(15 * 100), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.realTime()
                }).disposed(by: self.disposeBag)
            })
    }
}
