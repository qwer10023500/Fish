//
//  QHCalculatorViewController.swift
//  Fishs
//
//  Created by 小孩 on 2022/1/24.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class QHCalculatorViewController: QHBaseViewController {
    
    @IBOutlet weak var moneyView: UITextField!
    
    @IBOutlet weak var financingView: UITextField!
    
    @IBOutlet weak var tradeView: UITextField!
    
    @IBOutlet weak var targetView: UITextField!
    
    @IBOutlet weak var resultView: UILabel!
    
    override func structureUI() {
        super.structureUI()
        
        moneyView.text = Defaults.shared.money
        financingView.text = Defaults.shared.financing
        tradeView.text = Defaults.shared.trade
        targetView.text = Defaults.shared.target
        
        moneyView.rx.text.orEmpty.subscribe(onNext: { text in
            Defaults.shared.money = text
        }).disposed(by: rx.disposeBag)
        
        financingView.rx.text.orEmpty.subscribe(onNext: { text in
            Defaults.shared.financing = text
        }).disposed(by: rx.disposeBag)
        
        tradeView.rx.text.orEmpty.subscribe(onNext: { text in
            Defaults.shared.trade = text
        }).disposed(by: rx.disposeBag)
        
        targetView.rx.text.orEmpty.subscribe(onNext: { text in
            Defaults.shared.target = text
        }).disposed(by: rx.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func calculatorViewDidClick(_ sender: UIButton) {
        guard let moneyText = moneyView.text, let money = Double(moneyText), !moneyText.isEmpty else {
            let controller = UIAlertController(title: "money error", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        guard let financingText = financingView.text, let financing = Double(financingText), !financingText.isEmpty else {
            let controller = UIAlertController(title: "financing error", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        guard let tradeText = tradeView.text, let trade = Int(tradeText), !tradeText.isEmpty else {
            let controller = UIAlertController(title: "trade error", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        guard let targetText = targetView.text, let target = Double(targetText), !targetText.isEmpty else {
            let controller = UIAlertController(title: "target error", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
            return
        }
        
        // total
        var total = money + money * financing / 100
        var change: Double = 0
        var profit: Double = 0
        var string = String()
        for i in 1...trade {
            let currentProfit = total * target / 100
            profit += currentProfit
            change = money + profit
            total = change + change * financing / 100
            string.append(String(format: "第%ld次交易~~当次获利：%.2f~~当前本金：%.2f\n", i, currentProfit, total - change * financing / 100))
        }
        resultView.text = string
    }
}
