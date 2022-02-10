//
//  QHDetailViewModel.swift
//  Fishs
//
//  Created by 小孩 on 2022/2/10.
//

import UIKit
import RxCocoa
import RxSwift

final class QHDetailViewModel: QHViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let detail: AnyObserver<String>
    }
    
    struct Output {
        let detail: Driver<QHStockModel>
    }
    
    fileprivate let detailSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    init() {
        let detail = detailSubject.flatMapLatest { id -> Observable<QHStockModel> in
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
        
        input = Input(detail: detailSubject.asObserver())
        output = Output(detail: detail)
    }
}
