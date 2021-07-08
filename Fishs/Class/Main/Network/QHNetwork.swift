//
//  QHNetwork.swift
//  BigStart
//
//  Created by 小孩 on 2021/4/15.
//

import Moya
import RxSwift

class QHNetwork {
    typealias QHResponse = Result<Data, Error>
    
    fileprivate static var provider: MoyaProvider<QHDomain> {
        let provider = MoyaProvider<QHDomain>(plugins: [QHPlugin()])
        return provider
    }
    
    /** request */
    public static func request(_ domain: QHDomain) -> Observable<QHResponse> {
        return Observable<QHResponse>.create { (observer) -> Disposable in
            let cancellableToken = provider.request(domain) { (result) in
                switch result {
                case .success(let response):
                    observer.onNext(.success(response.data))
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
            }
            return Disposables.create { cancellableToken.cancel() }
        }
    }
}
