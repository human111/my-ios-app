//
//  SettingsScreen.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/4.
//

import SwiftUI

struct SettingsScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @AppStorage(.preferredWeightUnit) private var unit: WeightUnit
    @AppStorage(.startTab) private var startTab: HomeScreen.Tab = .picker
    
    @State private var confirmationDialog: Dialog = .inactive
    
    private var shouldShowDialog: Binding<Bool> {
        Binding(get: {
            confirmationDialog != .inactive
        }, set: {
            _ in confirmationDialog = .inactive
        })
    }

    var body: some View {
        // form表单
        Form {
            // 块样式
            Section("基本设定") {
                // 开关组件
                Toggle(isOn: $shouldUseDarkMode) {
                    Label("深色模式", systemImage: .moon)
                }

                // 选择框
                Picker(selection: $unit) {
                    ForEach(WeightUnit.allCases) { $0 }
                } label: {
                    Label("单位", systemImage: .unitSign)
                }
                
                Picker(selection: $startTab) {
                    Text("随机食物").tag(HomeScreen.Tab.picker)
                    Text("食物清单").tag(HomeScreen.Tab.list)
                } label: {
                    Label("启动动画", systemImage: .house)
                }
            }

            Section("危险区域") {
                ForEach(Dialog.allCases) { dialog in
                    Button(dialog.rawValue) {
                        confirmationDialog = dialog
                    }
                    // tint：按钮的强调色
                    .tint(Color(.label))
                }
            }
            .confirmationDialog(
                confirmationDialog.rawValue,
                isPresented: shouldShowDialog,
                titleVisibility: .visible
            ) {
                Button("确定", role: .destructive, action: confirmationDialog.action)
                Button("取消", role: .cancel) {}
            } message: {
                Text(confirmationDialog.message)
            }
        }
    }
}

private enum Dialog: String {
    case resetSettings = "重新设定"
    case resetFoodList = "重置食物记录"
    case inactive
    
    var message: String {
        switch self {
            case .resetSettings:
                return "将重置颜色、单位等设置，\n此操作无法复原，确定进行吗？"
            case .resetFoodList:
                return "将重置食物清单，\n此操作无法复原，确定进行吗？"
            case .inactive:
                return ""
        }
    }
    
    func action() {
        switch self {
            case .resetSettings:
                let keys: [UserDefaults.Key] = [.shouldUseDarkMode, .preferredWeightUnit, .startTab]
                for key in keys {
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                }
            case .resetFoodList:
                UserDefaults.standard.removeObject(forKey: UserDefaults.Key.foodList.rawValue)
            case .inactive:
                return
        }
    }
}

extension Dialog: CaseIterable {
    static let allCases: [Dialog] = [.resetSettings, .resetFoodList]
}

extension Dialog: Identifiable {
    var id: Self { self }
}

#Preview {
    SettingsScreen()
}
