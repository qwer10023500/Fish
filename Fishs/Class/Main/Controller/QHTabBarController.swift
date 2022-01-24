//
//  QHTabBarController.swift
//  Fishs
//
//  Created by 小孩 on 2022/1/24.
//

import UIKit

class QHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if isTransactionTime(start: "09:30:00", end: "15:00:00") {
            selectedIndex = 0
        } else {
            selectedIndex = 2
        }
    }
    
    /** transaction */
    fileprivate func isTransactionTime(start: String, end: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let string = dateFormatter.string(from: Date())
        guard let start = dateFormatter.date(from: start), let end = dateFormatter.date(from: end), let today = dateFormatter.date(from: string) else { return false }
        return today.compare(start) == .orderedDescending && today.compare(end) == .orderedAscending
    }
}
