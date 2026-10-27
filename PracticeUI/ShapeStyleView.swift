//
//  ShapeStyleView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/27.
//

import SwiftUI

struct ShapeStyleView: View {
    var body: some View {
        // VStack的子孩子，最多只能放10个，超过就会报错。常见的解决方案，可以使用Group去包装。
        // 这里的Circle().fill(.yellow).overlay等价下面的ZStack
        if false {VStack {
            //            Circle().fill(.teal)
            //            Circle().fill(.teal.gradient)
            //            Circle().fill(.image(.init("dinner"), scale: 0.2))
            //            Text("Hello")
            //                .font(.system(size: 100).bold())
            //                .foregroundStyle(.linearGradient(colors: [.pink, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
            // 这里的overlay类似ZStack，也就是z轴方向
            Circle().fill(.yellow).overlay {
                Text("Hello")
                    .font(.system(size: 100).bold())
                    .foregroundStyle(.linearGradient(colors: [.pink, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }}
        
        ZStack {
            Circle().fill(.yellow)
            // 这里zIndex，可以手动调整z轴的层级
            Circle().fill(.image(.init("dinner"), scale: 0.2)).zIndex(0)
            Text("Hello")
                .font(.system(size: 100).bold())
                .foregroundStyle(.linearGradient(colors: [.pink, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                .background { Color.bg2.scaleEffect(1.3).blur(radius: 20) }
        }
    }
}

#Preview {
    ShapeStyleView()
}
