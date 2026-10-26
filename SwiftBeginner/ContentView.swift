//
//  ContentView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/23.
//

import SwiftUI

struct ContentView: View {
    let food = Food.examples
    @State private var selectedFood: Food?
    @State private var showInfo: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
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
                
                Text("今天吃什么?")
                    .bold()
                
                if selectedFood != .none {
                    HStack{
                        
                        Text(selectedFood?.name ?? "")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.green)
                            .id(selectedFood?.name)
                            .transition(.asymmetric(
                                insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)),
                                removal: .opacity.animation(.easeInOut(duration: 0.4))
                            ))
                        
                        // .plain：没有做任何按钮风格的调整
                        Button (action: {
                            showInfo.toggle()
                        }, label: {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.secondary)
                        }).buttonStyle(.plain)
                    }
                    
                    Text("热量 \(selectedFood!.calorie.formatted()) 大卡")
                    
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
                        if showInfo {
                            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                                GridRow {
                                    Text("蛋白质")
                                    Text("脂肪")
                                    Text("碳水")
                                }.frame(minWidth: 60)
                                
                                Divider().gridCellUnsizedAxes(.horizontal).padding(.horizontal, -10)
                                
                                GridRow {
                                    Text("\(selectedFood!.protein.formatted()) g")
                                    Text("\(selectedFood!.fat.formatted()) g")
                                    Text("\(selectedFood!.carb.formatted()) g")
                                }
                                
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.systemBackground)))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .clipped()
                }
                
                // 填满剩余的区域，使用layoutPriority
                // 让Spacer先拿到剩余的空间
                Spacer().layoutPriority(1)
                
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
                
                Button {
                    selectedFood = .none
                    showInfo = false
                } label: {
                    Text("重置").frame(width: 200)
                }
                .buttonStyle(.bordered)
                            
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: UIScreen.main.bounds.height - 100)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .animation(.spring(duration: 0.5), value: showInfo)
            .animation(.easeInOut(duration: 0.6), value: selectedFood)
        }
        .background(Color(.secondarySystemBackground))
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
            
            ContentView(selectFood: .examples.first!)
                .previewDevice(.iPad)
                .previewDisplayName("iPad")
        }
    }
}
