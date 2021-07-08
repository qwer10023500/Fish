//
//  QHBaseModel.swift
//  Fishs
//
//  Created by 小孩 on 2021/7/8.
//

import UIKit

protocol QHViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class QHBaseModel: NSObject {

}
