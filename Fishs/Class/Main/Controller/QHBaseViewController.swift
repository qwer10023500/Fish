//
//  QHBaseViewController.swift
//  BigStart
//
//  Created by 小孩 on 2021/5/24.
//

import UIKit
import SnapKit

class QHBaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        structureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let `navigationController` = navigationController else { return }
        
        if navigationController.viewControllers.first == self { navigationController.interactivePopGestureRecognizer?.delegate = self }
        
        navigationController.navigationBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /** UI */
    public func structureUI() {
        
    }
    
    deinit {
        QHLog(NSStringFromClass(type(of: self)))
    }
}

// MARK: Public
extension QHBaseViewController {
    /** Push */
    public func qh_pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /** Present */
    public func qh_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

// MARK: UIGestureRecognizerDelegate
extension QHBaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let `navigationController` = navigationController, gestureRecognizer == navigationController.interactivePopGestureRecognizer else { return true }
        return navigationController.viewControllers.count != 1
    }
}
