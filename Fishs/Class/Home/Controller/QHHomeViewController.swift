//
//  QHHomeViewController.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import NSObject_Rx

class QHHomeViewController: QHBaseViewController {
    
    /** viewModel */
    fileprivate let viewModel = QHHomeViewModel()
    
    /** disposeBag */
    fileprivate var disposeBag = DisposeBag()
    
    /** home */
    fileprivate lazy var home = QHHomeModel()
    
    /** dateFormatter */
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    /** index */
    @IBOutlet weak var indexView: UICollectionView!
    
    /** stock */
    @IBOutlet weak var stockView: UITableView!
    
    override func structureUI() {
        super.structureUI()
        
        indexView.register(R.nib.qhIndexViewCell)
        stockView.register(R.nib.qhStockViewCell)
        
        let tableHeaderView = QHHomeTableHeaderView(home)
        tableHeaderView.delegate = self
        tableHeaderView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.bounds.width, height: 50))
        tableHeaderView.backgroundColor = UIColor.clear
        stockView.tableHeaderView = tableHeaderView
        
        MJRefreshNormalHeader { [weak self] in
            guard let `self` = self else { return }
            self.disposeBag = DisposeBag()
            self.viewModel.input.stocks.onNext(self.home)
        }.autoChangeTransparency(true)
        .link(to: stockView)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe(onNext: { [weak self] notification in
            guard let `self` = self else { return }
            self.viewModel.input.stocks.onNext(self.home)
        }).disposed(by: rx.disposeBag)
        
        viewModel.output.stocks.drive(onNext: { [weak self] home in
            guard let `self` = self else { return }
            self.home = home
            self.indexView.reloadData()
            self.stockView.reloadData()
            self.stockView.mj_header?.endRefreshing()
            self.update()
        }).disposed(by: rx.disposeBag)
        
        viewModel.output.check.drive(onNext: { [weak self] stock in
            guard let `self` = self, !stock.id.isEmpty else { return }
            let categories = self.home.categories
            for category in categories {
                guard category.isSelected else { continue }
                category.stocks.append(stock)
                break
            }
            self.home.categories = categories
            self.stockView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        viewModel.input.stocks.onNext(home)
        
        NotificationCenter.default.rx.notification(Notification.Name("longPress.QHStockTableHeaderViewCell")).subscribe(onNext: { [weak self] notification in
            guard let `self` = self, let category = notification.object as? QHCategoryModel else { return }
            let controller = UIAlertController(title: "Delete Category?", message: "", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Done", style: .destructive, handler: { _ in
                var categories = Defaults.shared.categories
                for item in categories.enumerated() {
                    if item.element.name == category.name && item.element.stocks.count == category.stocks.count { categories.remove(at: item.offset) }
                }
                Defaults.shared.categories = categories
                tableHeaderView.collectionView.reloadData()
            }))
            self.present(controller, animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
    }
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "", message: "", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let alertAction = UIAlertAction(title: "Done", style: .default) { [weak controller] _ in
            guard let `controller` = controller, let text = controller.textFields?.first?.text else { return }
            var string = text
            if text.hasPrefix("6") {
                string = "sh\(text)"
            } else if text.hasPrefix("0") || text.hasPrefix("3") || text.hasPrefix("1") {
                string = "sz\(text)"
            }
            self.viewModel.input.check.onNext(string)
        }
        controller.addAction(alertAction)
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
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        stockView.setEditing(!stockView.isEditing, animated: true)
    }
}

// MARK: Private
extension QHHomeViewController {
    /** selected  category */
    fileprivate func category() -> QHCategoryModel {
        return home.categories.filter({ category in return category.isSelected }).first ?? QHCategoryModel()
    }
    
    /** update stock */
    fileprivate func update() {
        guard UIApplication.shared.applicationState == .active else { return }
        guard isTransactionTime(start: "09:30:00", end: "11:30:00") || isTransactionTime(start: "13:00:00", end: "14:57:00") else { return }
        Observable.just(()).delay(.milliseconds(15 * 100), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            guard !self.stockView.isEditing else {
                self.update()
                return
            }
            self.viewModel.input.stocks.onNext(self.home)
        }).disposed(by: self.disposeBag)
    }
    
    /** transaction */
    fileprivate func isTransactionTime(start: String, end: String) -> Bool {
        let string = dateFormatter.string(from: Date())
        guard let start = dateFormatter.date(from: start), let end = dateFormatter.date(from: end), let today = dateFormatter.date(from: string) else { return false }
        return today.compare(start) == .orderedDescending && today.compare(end) == .orderedAscending
    }
}

// MARK: UICollectionViewDataSource
extension QHHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return home.indexs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.qhIndexViewCell, for: indexPath) else { return UICollectionViewCell() }
        cell.stock = home.indexs[indexPath.item]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension QHHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = R.storyboard.main.qhDetailViewController() else { return }
        controller.stock = home.indexs[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: UITableViewDataSource
extension QHHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category().stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.qhStockViewCell, for: indexPath) else { return UITableViewCell() }
        cell.stock = category().stocks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let categories = home.categories
        for category in categories {
            guard category.isSelected else { continue }
            category.stocks.remove(at: indexPath.row)
            break
        }
        home.categories = categories
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let categories = home.categories
        for category in categories {
            guard category.isSelected else { continue }
            var array = category.stocks
            let item = array[sourceIndexPath.row]
            array.remove(at: sourceIndexPath.row)
            array.insert(item, at: destinationIndexPath.row)
            category.stocks = array
            break
        }
        home.categories = categories
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: UITableViewDelegate
extension QHHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = R.storyboard.main.qhDetailViewController() else { return }
        controller.stock = category().stocks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: QHHomeTableHeaderViewDelegate
extension QHHomeViewController: QHHomeTableHeaderViewDelegate {
    func add(_ tableHeaderView: QHHomeTableHeaderView) {
        let controller = UIAlertController(title: "", message: "", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak controller] _ in
            guard let `controller` = controller, let text = controller.textFields?.first?.text else { return }
            var categories = self.home.categories
            categories.append(QHCategoryModel(text, isSelected: false))
            self.home.categories = categories
            tableHeaderView.collectionView.reloadData()
        }))
        present(controller, animated: true, completion: nil)
    }
    
    func selectItem(_ tableHeaderView: QHHomeTableHeaderView, indexPath: IndexPath) {
        viewModel.input.stocks.onNext(home)
        disposeBag = DisposeBag()
    }
}
