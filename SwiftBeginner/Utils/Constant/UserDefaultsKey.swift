//
//  UserDefaultsKey.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/5.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case shouldUseDarkMode
        // 用preferredEnergyUnit和preferredWeightUnit替代了
//        case unit
        case startTab
        case foodList
        case preferredEnergyUnit
        case preferredWeightUnit
    }
}
