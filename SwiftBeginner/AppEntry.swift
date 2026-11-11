//
//  AppEntry.swift
//  SwiftBeginner
//  Use github for recording
//
//  Created by ghy on 2026/10/23.
//

import SwiftUI

@main
struct AppEntry: App {
    init() {
        applyTabBarBackground()
    }
    
    var body: some Scene {
        WindowGroup {
//            FoodPickerScreen()
            HomeScreen().environmentObject(CatAPIManager.shared)
        }
    }
    
    func applyTabBarBackground() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.3)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
