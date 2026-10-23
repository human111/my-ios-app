//
//  ContentView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/23.
//

import SwiftUI

struct ContentView: View {
    let food = ["汉堡", "沙拉", "披萨", "意大利面", "鸡腿便当", "刀削面", "火锅", "牛肉面", "关东煮", ]
    @State private var selectedFood: String?
    
    var body: some View {
        VStack(spacing: 30) {
            // 这样写，表示需要到assets中去找dinner命名的图片
            Image("dinner")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("今天吃什么")
                .font(.title)
                .bold()
            
            if selectedFood != .none {
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.green)
            }
            
            Button(role: .none) {
                selectedFood = food.shuffled().first { $0 != selectedFood }
            } label: {
                Text(selectedFood == .none ? "告诉我" : "换一个").frame(width: 200)
            }
            .padding(.bottom, -15)
            
            Button(role: .none) {
                selectedFood = .none
            } label: {
                Text("重置").frame(width: 200)
            }
            .buttonStyle(.bordered)
                        
        }
        .padding()
        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color(.secondarySystemBackground))
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .animation(.easeInOut, value: selectedFood)
    }
}

/**
 以前的预览写法
 */
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

#Preview {
    ContentView()
}
