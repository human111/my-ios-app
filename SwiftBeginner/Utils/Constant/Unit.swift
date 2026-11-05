//
//  Unit.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/5.
//

import SwiftUI

enum Unit: String, CaseIterable, Identifiable, View {
    case gram = "g", pound = "lb"

    var id: Self { self }

    // 配合ForEach的枚举view
    var body: some View {
        Text(rawValue)
    }
}
