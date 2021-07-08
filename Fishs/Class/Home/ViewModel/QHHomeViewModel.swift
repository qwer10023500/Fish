//
//  QHHomeViewModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit
import RxCocoa
import RxSwift

class QHHomeViewModel: QHViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let stocks: AnyObserver<[String]>
    }
    
    struct Output {
        let stocks: Driver<[QHStockModel]>
    }
    
    fileprivate let stocksSubject = ReplaySubject<[String]>.create(bufferSize: 1)
    
    init() {
        let stocks = stocksSubject.flatMapLatest { ids -> Observable<[QHStockModel]> in
            return QHNetwork.request(.market(ids: ids)).flatMapLatest { result -> Observable<[QHStockModel]> in
                switch result {
                case .success(let value):
                    let cfEncoding = CFStringEncodings.GB_18030_2000
                    let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                    guard let string = NSString(data: value, encoding: encoding) else { return Observable.just([QHStockModel]()) }
                    var stocks = [QHStockModel]()
                    for item in string.components(separatedBy: "\n") {
                        guard item.count != 0 else { continue }
                        let stock = QHStockModel.parsing(item)
                        stocks.append(stock)
                    }
                    return Observable.just(stocks)
                case .failure:
                    return Observable.just([QHStockModel]())
                }
            }
        }.asDriver(onErrorJustReturn: [QHStockModel]())
        
        input = Input(stocks: stocksSubject.asObserver())
        output = Output(stocks: stocks)
    }
}
