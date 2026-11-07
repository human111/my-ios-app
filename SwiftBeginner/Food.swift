//
//  Food.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/26.
//

import SwiftUI

struct Food: Equatable, Identifiable {
    var id = UUID()
    var name: String
    var image: String
//    @Suffix var calorie: Double
//    @Suffix var carb: Double
//    @Suffix var fat: Double
//    @Suffix var protein: Double
    @Energy var calorie: Double
    @Weight var carb: Double
    @Weight var fat: Double
    @Weight var protein: Double
}

extension Food {
    static var new: Food { 
        let preferredWeightUnit = WeightUnit.getPreferredUnit()
        let preferredEnergyUnit = EnergyUnit.getPreferredUnit()
        
        return Food(
            name: "",
            image: "",
            calorie: .init(wrappedValue: .zero, preferredEnergyUnit),
            carb: .init(wrappedValue: .zero, preferredWeightUnit),
            fat: .init(wrappedValue: .zero, preferredWeightUnit),
            protein: .init(wrappedValue: .zero, preferredWeightUnit)
        )
    }
    
    private init(id: UUID = UUID(), name: String, image: String, calorie: Double, carb: Double, fat: Double, protein: Double) {
        self.id = id
        self.name = name
        self.image = image
        self._calorie = .init(wrappedValue: calorie, .cal)
        self._carb    = .init(wrappedValue: carb, .gram)
        self._fat     = .init(wrappedValue: fat, .gram)
        self._protein = .init(wrappedValue: protein, .gram)
    }
    
    static let examples = [
        Food(name: "汉堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Food(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Food(name: "披萨", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Food(name: "意大利面", image: "🍝", calorie: 449, carb: 88, fat: 2.1, protein: 12),
        Food(name: "鸡腿便当", image: "🍗🍱", calorie: 176, carb: 15, fat: 8.9, protein: 11.7),
        Food(name: "刀削面", image: "🍜", calorie: 276, carb: 56, fat: 1, protein: 6),
        Food(name: "火锅", image: "🍲🔥", calorie: 222, carb: 23.6, fat: 18, protein: 20.1),
        Food(name: "牛肉面", image: "🐮🍜", calorie: 310, carb: 33.2, fat: 6, protein: 6),
        Food(name: "关东煮", image: "🍢", calorie: 90, carb: 4, fat: 5, protein: 7),
    ]
}

extension Food: Codable {}
