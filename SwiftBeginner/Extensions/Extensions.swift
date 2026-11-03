//
//  Extensions.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/26.
//

import SwiftUI

// 针对view下，按钮相关样式的打包
extension View {
    // 这里建立方法，方法是通过实例本身去调用的
    func mainButtonStyle(shape: ButtonBorderShape = .capsule) -> some View {
        buttonStyle(.borderedProminent)
        .buttonBorderShape(shape)
        .controlSize(.large)
    }
    
    func roundedRectBackground(
        radius: CGFloat = 8,
        fill: some ShapeStyle = .bg
    ) -> some View {
        background(RoundedRectangle(cornerRadius: 8).fill(fill))
    }
    
    func sheet(item: Binding<(some View & Identifiable)?>) -> some View {
        sheet(item: item) { $0 }
    }
    
    // 使用方法将frame(maxWidth: .infinity, alignment: .leading)类似的调整器，都可以替换成.push(to: .leading)等
    // 注意tag，一定要大写Tag，链接才能跳转
    /// - Tag: push
    func push(to alignment: TextAlignment) -> some View {
        switch alignment {
        case .leading:
            return frame(maxWidth: .infinity, alignment: .leading)
        case .center:
            return frame(maxWidth: .infinity, alignment: .center)
        case .trailing:
            return frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    /// Shortcut: [push(to: .center)](x-source-tag://push) 使用最大的宽度
    func maxWidth() -> some View {
        push(to: .center)
    }
    
    func readGeometry<Key: PreferenceKey, Value>(
        _ keyPath: KeyPath<GeometryProxy, Value>,
        key: Key.Type
    ) -> some View where Key.Value == Value {
        overlay {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: key,
                    value: proxy[keyPath: keyPath]
                )
            }
        }
    }
}

// 在Animation下，自定义打包的静态属性
extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.5)
    static let myEase = Animation.easeInOut(duration: 0.6)
}

// 自定义Color相关的静态属性
extension ShapeStyle where Self == Color {
    static var bg: Color { Color(.systemBackground) }
    static var bg2: Color {  Color(.secondarySystemBackground) }
    static var groupBg: Color {  Color(.systemGroupedBackground) }
}

extension AnyTransition {
    static let moveUpWithOpacity = Self.move(edge: .top).combined(with: .opacity)
    
    static let delayInsertionOpacity = Self.asymmetric(
        insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)),
        removal: .opacity.animation(.easeInOut(duration: 0.4))
    )
}

extension AnyLayout {
    static func useVStack(if condition: Bool, spacing: CGFloat, @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: 30)) : AnyLayout(HStackLayout(spacing: 30))
        
        return layout(content)
    }
}
