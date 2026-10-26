//
//  Food.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/26.
//

struct Food: Equatable {
    var name: String
    var image: String
    var calorie: Double
    var carb: Double
    var fat: Double
    var protein: Double
    
    static let examples = [
        Food(name: "汉堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Food(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Food(name: "披萨", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Food(name: "意大利面", image: "🍝", calorie: 449, carb: 88, fat: 2.1, protein: 12),
        Food(name: "鸡腿便当", image: "🍗🍱", calorie: 176, carb: 15, fat: 8.9, protein: 11.7),
        Food(name: "刀削面", image: "🍜", calorie: 276, carb: 56, fat: 1, protein: 6),
        Food(name: "火锅", image: "🍲", calorie: 222, carb: 23.6, fat: 18, protein: 20.1),
        Food(name: "牛肉面", image: "🐮🍜", calorie: 310, carb: 33.2, fat: 6, protein: 6),
        Food(name: "关东煮", image: "🍢", calorie: 90, carb: 4, fat: 5, protein: 7),
    ]
}
