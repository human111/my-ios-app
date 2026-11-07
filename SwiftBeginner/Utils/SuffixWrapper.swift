//
//  SuffixWrapper.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/26.
//

import Foundation

typealias Energy = Suffix<EnergyUnit>
typealias Weight = Suffix<WeightUnit>

// 针对Food文件中，相关变量存在单位的字符串拼接封装
@propertyWrapper 
struct Suffix<Unit: MyUnitProtocol & Equatable>: Equatable {
    var wrappedValue: Double
//    private let unit: Unit
    var unit: Unit
    var store: UserDefaults = .standard
    
    init(wrappedValue: Double, _ unit: Unit, store: UserDefaults = .standard) {
        self.wrappedValue = wrappedValue
        self.unit = unit
        self.store = store
    }
    
    // 主要是方便ContentView中使用$calorie取值，例如：selectedFood!.$calorie
    var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    
    var description: String {
        let preferredUnit = Unit.getPreferredUnit(from: store)
        // TODO: Measurement
        let measurement = Measurement(value: wrappedValue, unit: unit.dimension)
        let converted = measurement.converted(to: preferredUnit.dimension)
        return converted.value.formatted(.number.precision(.fractionLength(0...1))) + " " + preferredUnit.localizedSymbol
    }
    
}

extension Suffix: Codable {
    enum CodingKeys: CodingKey {
        case wrappedValue
        case unit
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Suffix<Unit>.CodingKeys> = try decoder.container(keyedBy: Suffix<Unit>.CodingKeys.self)
        
        self.wrappedValue = try container.decode(Double.self, forKey: Suffix<Unit>.CodingKeys.wrappedValue)
        self.unit = try container.decode(Unit.self, forKey: Suffix<Unit>.CodingKeys.unit)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Suffix<Unit>.CodingKeys.self)
        
        try container.encode(self.wrappedValue, forKey: Suffix.CodingKeys.wrappedValue)
        try container.encode(self.unit, forKey: Suffix.CodingKeys.unit)
    }
}
