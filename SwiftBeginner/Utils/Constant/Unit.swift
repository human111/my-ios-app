//
//  Unit.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/5.
//

import SwiftUI

protocol MyUnitProtocol: Codable, Identifiable, CaseIterable, View, RawRepresentable where RawValue == String, AllCases: RandomAccessCollection {
    associatedtype T: Dimension
    
    static var userDefaultsKey: UserDefaults.Key { get }
    static var defaultUnit: Self { get }
    
    var dimension: T { get }
}

// 方便取值
// 例如，原先是这样写的 @AppStorage(.preferredWeightUnit) var preferredWeightUnit: WeightUnit
// 现在可以写成这样 let preferredWeightUnit = WeightUnit.getPreferredUnit()
extension MyUnitProtocol {
    // from store: UserDefaults = .standard，方便测试传一个参数过来
    static func getPreferredUnit(from store: UserDefaults = .standard) -> Self {
        AppStorage(userDefaultsKey, store: store).wrappedValue
    }
}

enum EnergyUnit: String, MyUnitProtocol {
    static var userDefaultsKey: UserDefaults.Key = .preferredEnergyUnit
    
    static var defaultUnit: EnergyUnit = .cal
    
    case cal = "大卡"
    
    var dimension: UnitEnergy {
        switch self {
            case .cal:
                return .calories
        }
    }
}

enum WeightUnit: String, MyUnitProtocol {
    case gram = "g", pound = "lb", ounce
    
    var dimension: UnitMass {
        switch self {
            case .gram:
                return .grams
            case .pound:
                return .pounds
            case .ounce:
                return .ounces
        }
    }
    
    static var userDefaultsKey: UserDefaults.Key = .preferredWeightUnit
    
    static var defaultUnit: WeightUnit = .gram
}

extension MyUnitProtocol {
    var localizedSymbol: String {
        // 当前 Bundle 优先使用的本地化语言列表。例如：["zh-Hans", "en"]
//        print(Bundle.main.preferredLocalizations)
        // 手动指定中文
//        let formatter = MeasurementFormatter()
//        formatter.locale = Locale(identifier: "zh_CN") // 手动制定地区配合使用对应的单位
        
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        let locale = Locale(identifier: language)
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        
        
        formatter.unitStyle = .long

        return formatter.string(from: dimension)
    }
    
    // 配合ForEach的枚举view
    var body: some View {
//        Text(rawValue)
//        Text(dimension.symbol)
//        Text(dimension.localizedSymbol)
        Text(localizedSymbol)
    }
}

extension MyUnitProtocol {
    var id: Self { self }
}

// 对app编辑scheme的options中app language后，跟随本地语言单位的配置不生效
//extension Unit {
//    var localizedSymbol: String {
//        MeasurementFormatter().string(from: self)
//    }
//}

//extension Unit {
//    var localizedSymbol: String {
//        // 当前 Bundle 优先使用的本地化语言列表。例如：["zh-Hans", "en"]
////        print(Bundle.main.preferredLocalizations)
//        // 手动指定中文
////        let formatter = MeasurementFormatter()
////        formatter.locale = Locale(identifier: "zh_CN") // 手动制定地区配合使用对应的单位
//        
//        let language = Bundle.main.preferredLocalizations.first ?? "en"
//        let locale = Locale(identifier: language)
//        let formatter = MeasurementFormatter()
//        formatter.locale = locale
//        
//        
//        formatter.unitStyle = .long
//
//        return formatter.string(from: self)
//    }
//}

