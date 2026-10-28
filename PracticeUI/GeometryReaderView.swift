//
//  GeometryReaderView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/28.
//

import SwiftUI

// MARK: 显示的文字
extension CGPoint {
    public var description: String { "x: \(Int(x)), y: \(Int(y))" }
}

extension CGSize {
    public var description: String { "\(Int(width)) x \(Int(height))" }
}

extension CGRect {
    var endPosition: CGPoint { .init(x: maxX, y: maxY) }
    
    var coverage: String {
        origin.description + " ~ " + endPosition.description
    }
}

fileprivate struct GeometryReaderView: View {
    @State private var spacing: CGFloat = 0
    
    var body: some View {
        VStack {
            sliderView
            
            Color.bg2.frame(height: spacing)
            
            GeometryReader { proxy in
                let size: CGSize = proxy.size
                let global: CGRect = proxy.frame(in: .global)
                let local: CGRect = proxy.frame(in: .local)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("大小：" + size.description)
                    Text("Global坐标：\n" + global.coverage)
                    Text("Local坐标：\n" + local.coverage)
                }.padding().border(.orange, width: 2)
            }
            .border(.green.opacity(0.5), width: 4)
        }.font(.title3)
    }
    
    private var sliderView: some View {
        Text("待处理")
    }
}

#Preview {
    GeometryReaderView()
}
