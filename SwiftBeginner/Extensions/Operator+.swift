//
//  Operator+.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/11.
//

import Foundation

// 自定义操作符
func ==<T, Value: Equatable>(keyPath: KeyPath<T, Value>, value: Value) -> (T) -> Bool {
    { $0[keyPath: keyPath] == value }
}
