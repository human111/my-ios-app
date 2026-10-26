//
//  SuffixWrapper.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/26.
//

// 针对Food文件中，相关变量存在单位的字符串拼接封装
@propertyWrapper struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, _ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    // 主要是方便ContentView中使用$calorie取值，例如：selectedFood!.$calorie
    var projectedValue: String {
        wrappedValue.formatted() + " \(suffix)"
    }
}
