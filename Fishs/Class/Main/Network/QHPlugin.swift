//
//  QHPlugin.swift
//  BigStart
//
//  Created by 小孩 on 2021/4/15.
//

import Moya

struct QHPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let url = request.url { QHLog(url) }
        return request
    }
}
