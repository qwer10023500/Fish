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
        let stocks: AnyObserver<QHHomeModel>
        let check: AnyObserver<String>
    }
    
    struct Output {
        let stocks: Driver<QHHomeModel>
        let check: Driver<QHStockModel>
    }
    
    fileprivate let stocksSubject = ReplaySubject<QHHomeModel>.create(bufferSize: 1)
    fileprivate let checkSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    init() {
        let stocks = stocksSubject.flatMapLatest { home -> Observable<QHHomeModel> in
            var ids = [String]()
            ids.append(contentsOf: home.indexs.map { stock -> String in return stock.id })
            for categoriey in home.categories {
                guard categoriey.isSelected else { continue }
                for stock in categoriey.stocks { ids.append(stock.id) }
                break
            }
            return QHNetwork.request(.market(ids: ids)).flatMapLatest { result -> Observable<QHHomeModel> in
                switch result {
                case .success(let value):
                    let cfEncoding = CFStringEncodings.GB_18030_2000
                    let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                    guard let string = NSString(data: value, encoding: encoding) else { return Observable.just(home) }
                    var stocks = [QHStockModel]()
                    for item in string.components(separatedBy: "\n") {
                        guard item.count != 0 else { continue }
                        let stock = QHStockModel.parsing(item)
                        stocks.append(stock)
                    }
                    
                    home.indexs = stocks.filter({ stock in return stock.mode == .index })
                    let categories = home.categories
                    for categoriey in categories {
                        guard categoriey.isSelected else { continue }
                        for stock in categoriey.stocks {
                            for new in stocks.filter({ stock in return stock.mode == .stock }) {
                                guard stock == new else { continue }
                                stock.id = new.id
                                stock.mode = new.mode
                                stock.name = new.name
                                stock.price = new.price
                                stock.fluctuation = new.fluctuation
                                stock.point = new.point
                                stock.max = new.max
                                stock.min = new.min
                                stock.start = new.start
                                stock.yesterday = new.yesterday
                            }
                        }
                        break
                    }
                    home.categories = categories
                    return Observable.just(home)
                case .failure:
                    return Observable.just(home)
                }
            }
        }.asDriver(onErrorJustReturn: QHHomeModel())
        
        let check = checkSubject.flatMapLatest { id -> Observable<QHStockModel> in
            return QHNetwork.request(.market(ids: [id])).flatMapLatest { result -> Observable<QHStockModel> in
                switch result {
                case .success(let value):
                    let cfEncoding = CFStringEncodings.GB_18030_2000
                    let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                    guard let string = NSString(data: value, encoding: encoding) else { return Observable.just(QHStockModel()) }
                    var stock = QHStockModel()
                    for item in string.components(separatedBy: "\n") {
                        guard item.count != 0 else { continue }
                        stock = QHStockModel.parsing(item)
                    }
                    return Observable.just(stock)
                case .failure:
                    return Observable.just(QHStockModel())
                }
            }
        }.asDriver(onErrorJustReturn: QHStockModel())
        
        input = Input(stocks: stocksSubject.asObserver(), check: checkSubject.asObserver())
        output = Output(stocks: stocks, check: check)
    }
}
