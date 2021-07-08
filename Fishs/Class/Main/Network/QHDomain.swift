//
//  QHDomain.swift
//  BigStart
//
//  Created by 小孩 on 2021/4/15.
//

import Moya

enum QHDomain {
    /** real-time market */
    case market(ids: [String])
}

extension QHDomain: TargetType {
    var baseURL: URL {
        switch self {
        case .market(let ids):
            return URL(string: "https://hq.sinajs.cn/list=\(ids.joined(separator: ","))")!
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
}

extension QHDomain {
    var path: String {
        return String()
    }
    
    var method: Moya.Method {
        switch self {
        case .market:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .market:
            return .requestPlain
        }
    }
}
