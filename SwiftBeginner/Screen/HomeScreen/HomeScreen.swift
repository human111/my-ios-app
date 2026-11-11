//
//  HomeScreen.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/4.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage(.shouldUseDarkMode) var shouldUseDarkMode = false
//    @State var tab: Tab = .settings
    @State var tab: Tab = {
        let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue) ?? ""
        return Tab(rawValue: rawValue) ?? .images
    }()
    
    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { $0 }
        }.preferredColorScheme(shouldUseDarkMode ? .dark : .light)
    }
}

extension HomeScreen {
    enum Tab: String, View, CaseIterable {
        case picker, list, settings, images, favorites

        var body: some View {
            content.tabItem { tabLabel.labelStyle(.iconOnly) }
        }

        @ViewBuilder
        private var content: some View {
            switch self {
                case .picker:
                    FoodPickerScreen()
                case .list:
                    FoodListView()
                case .settings:
                    SettingsScreen()
                case .images:
                    CatImageScreen()
                case .favorites:
                    FavoriteScreen()
            }
        }

        private var tabLabel: some View {
            switch self {
                case .picker:
                    return Label("Home", systemImage: .house)
                case .list:
                    return Label("List", systemImage: .list)
                case .settings:
                    return Label("Settings", systemImage: .gear)
                case .images:
                    return Label("Cat", systemImage: .photo)
                case .favorites:
                    return Label("Favorites", systemImage: .heart)
            }
        }
    }
}

#Preview {
    HomeScreen()
}

//struct HomeScreen_Previews: PreviewProvider, View {
//    @AppStorage(.startTab) var startTab = HomeScreen.Tab.picker
//    
//    var body: some View {
//        HomeScreen(tab: startTab)
//    }
//    
//    static var previews: some View  {
//        Self()
//    }
//}
