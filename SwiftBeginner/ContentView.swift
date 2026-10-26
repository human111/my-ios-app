//
//  ContentView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFood: Food?
    @State private var shouldShowInfo: Bool = false
    
    let food = Food.examples
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                foodImage
                
                Text("今天吃什么?").bold()
                
                selectedFoodInfoView

                // 填满剩余的区域，使用layoutPriority，让Spacer先拿到剩余的空间
                Spacer().layoutPriority(1)
                
                selectFoodButton
                
                cancelFoodButton
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: UIScreen.main.bounds.height - 100)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .mainButtonStyle()
            .animation(.mySpring, value: shouldShowInfo)
            .animation(.myEase, value: selectedFood)
        }
        .background(Color.bg2)
    }
}

// MARK: -Subviews

private extension ContentView {
    var foodImage: some View {
        Group {
            if selectedFood != .none {
                Text(selectedFood!.image)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
            } else {
                // 这样写，表示需要到assets中去找dinner命名的图片
                Image("dinner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 249)
    }
    
    var foodNameView: some View {
        HStack{
            Text(selectedFood?.name ?? "")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.green)
                .id(selectedFood?.name)
                .transition(.delayInsertionOpacity)
            
            // .plain：没有做任何按钮风格的调整
            Button (action: {
                shouldShowInfo.toggle()
            }, label: {
                Image(systemName: "info.circle.fill").foregroundColor(.secondary)
            }).buttonStyle(.plain)
        }
    }
    
    var foodDetailView: some View {
        // 两种样式的写法，样式一：自定义更强
//                    HStack {
//                        VStack(spacing: 12) {
//                            Text("蛋白质")
//                            Text("\(selectedFood!.protein.formatted()) g")
//                        }
//
//                        Divider().frame(width: 1).padding(.horizontal)
//
//                        VStack(spacing: 12) {
//                            Text("脂肪")
//                            Text("\(selectedFood!.fat.formatted()) g")
//                        }
//
//                        Divider().frame(width: 1).padding(.horizontal)
//
//                        VStack(spacing: 12) {
//                            Text("碳水")
//                            Text("\(selectedFood!.carb.formatted()) g")
//                        }
//
//                    }
        
        // 加上VStack是为了让info的模块，在制定的区域内进行相应的动画效果
        VStack {
            // 样式二：写法更简洁
            if shouldShowInfo {
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        Text("蛋白质")
                        Text("脂肪")
                        Text("碳水")
                    }.frame(minWidth: 60)
                    
                    Divider().gridCellUnsizedAxes(.horizontal).padding(.horizontal, -10)
                    
                    GridRow {
                        // 写法一
                        Text(selectedFood!.$protein)
                        Text(selectedFood!.$fat)
                        Text(selectedFood!.$carb)
                        // 写法二
//                        buildNutritionNumberText(selectedFood!.protein)
//                        buildNutritionNumberText(selectedFood!.fat)
//                        buildNutritionNumberText(selectedFood!.carb)
                    }
                    
                }
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .roundedRectBackground()
                .transition(.moveUpWithOpacity)
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }
    
//    func buildNutritionNumberText(_ number: Double) -> some View {
//        Text("\(number.formatted()) g")
//    }
    
    @ViewBuilder var selectedFoodInfoView: some View {
        if selectedFood != .none {
            foodNameView
            
            Text("热量 \(selectedFood!.$calorie)").font(.title2)
            
            foodDetailView
        }
    }
    
    var selectFoodButton: some View {
        Button {
            selectedFood = food.shuffled().first { $0 != selectedFood }
        } label: {
            // 这里的animation相当于覆盖了外层VStack的动效
            Text(selectedFood == .none ? "告诉我" : "换一个")
                .frame(width: 200)
                .animation(.none, value: selectedFood)
                .transformEffect(.identity)
        }
        .padding(.bottom, -15)
    }
    
    var cancelFoodButton: some View {
        Button {
            selectedFood = .none
            shouldShowInfo = false
        } label: {
            Text("重置").frame(width: 200)
        }
        .buttonStyle(.bordered)
    }
    
}

extension ContentView {
    init(selectFood: Food) {
        _selectedFood = State(wrappedValue: selectFood)
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

// 也可以不添加("iPhone")，默认就是手机模式。
//#Preview("iPhone") {
//    ContentView(selectFood: .examples.first!)
//    // 设置一个ipad的预览
////    ContentView(selectFood: .examples.first!).previewDevice(.iPad)
//}

// .previewDevice(...) 这个修饰符在 #Preview 宏里基本不生效,它是给旧的 PreviewProvider 用的。
// #Preview 里的设备由画布底部的设备按钮决定。
//#Preview("iPhone 15 Pro") {
//    ContentView(selectFood: .examples.first!)
//        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
//}
//
//#Preview("iPad Pro 11") {
//    ContentView(selectFood: .examples.first!)
//        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(selectFood: .examples.first!)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone")
            
//            ContentView(selectFood: .examples.first!)
//                .previewDevice(.iPad)
//                .previewDisplayName("iPad")
        }
    }
}
