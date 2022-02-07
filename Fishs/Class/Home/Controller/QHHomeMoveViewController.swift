//
//  QHHomeMoveViewController.swift
//  Fishs
//
//  Created by 小孩 on 2022/2/7.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class QHHomeMoveViewController: QHBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var callBack: (() -> Void)?
    
    override func structureUI() {
        super.structureUI()
        
        let backItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        backItem.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.callBack?()
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        navigationItem.leftBarButtonItem = backItem

        tableView.register(R.nib.qhMoveViewCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.setEditing(true, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension QHHomeMoveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults.shared.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.qhMoveViewCell, for: indexPath) else { return UITableViewCell() }
        cell.textLabel?.text = Defaults.shared.categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        var categories = Defaults.shared.categories
        categories.remove(at: indexPath.row)
        Defaults.shared.categories = categories
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var categories = Defaults.shared.categories
        let item = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(item, at: destinationIndexPath.row)
        Defaults.shared.categories = categories
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}
