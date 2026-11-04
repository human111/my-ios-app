//
//  Sheet.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/3.
//

import SwiftUI

extension FoodListView {
    enum Sheet: View, Identifiable {
        case newFood((Food) -> Void)
        case editFood(Binding<Food>)
        case foodDetail(Food)
        
        var id: Food.ID {
            switch self {
                case .newFood:
                    return UUID()
                case .editFood(let binding):
                    return binding.wrappedValue.id
                case .foodDetail(let food):
                    return food.id
            }
        }
        
        var body: some View {
            switch self {
                case .newFood(let onSubmit):
                    FoodForm(food: .new, onSubmit: onSubmit)
                case .editFood(let binding):
                    FoodForm(food: binding.wrappedValue) {
                        binding.wrappedValue = $0
                    }
                case .foodDetail(let food):
                    FoodDetailSheet(food: food)
            }
        }
    }
}
