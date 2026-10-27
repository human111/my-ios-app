//
//  FoodListView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/27.
//

import SwiftUI

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.dynamicTypeSize) var textSize
    @State private var foods = Food.examples
    @State private var selectedFood = Set<Food.ID>()
    
    var isEditing: Bool { editMode?.wrappedValue == .active }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleBar
            
            // 这里因为$food是Binding，在用“food in”遍历的时候，要使用wrappedValue才能获取到对象的值
            // 如果不想使用wrappedValue，可以用“$food in”的写法
            List($foods, editActions: .all, selection: $selectedFood) { $food in
                Text(food.name).padding(.vertical, 10)
            }
            .listStyle(.plain)
            .padding(.horizontal)
            
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(isPresented: .constant(true)) {
            // presentationDetents：给sheet设置高度，medium到屏幕中间的位置，height(500)最高500
//            Text("Hello")
//                .presentationDetents([.medium, .height(500)])
//            let food = foods.first!
            let food = foods[4]
            
            // 根据不同的条件，来显示不通的布局（可以理解为动态布局）
            let shouldVStack = textSize.isAccessibilitySize || food.image.count > 1
            AnyLayout.useVStack(if: shouldVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Grid(horizontalSpacing: 30, verticalSpacing: 12) {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                    
                }
            }
            .presentationDetents([.medium])
        }
        
    }
}

private extension FoodListView {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: "fork.knife")
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
            
            EditButton()
                .buttonStyle(.bordered)
        }.padding()
    }
    
    var addButton: some View {
        Button {} label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette) // 使用色盘来给图片配色
                .foregroundStyle(.white, Color.accentColor.gradient)
        }
    }
    
    var removeButton: some View {
        Button {
            // 不想用外层的animation的样式，这里使用withAnimation
            withAnimation {
                foods = foods.filter { !selectedFood.contains($0.id) }
            }
        } label: {
            Text("删除全部")
                .font(.title2.bold())
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .mainButtonStyle(shape: .roundedRectangle(radius: 8))
        .padding(.horizontal, 50)
    }
    
    func buildFloatButton() -> some View {
        ZStack {
            removeButton
                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                .opacity(isEditing ? 1 : 0)
                .id(isEditing)
            
            // 这样写，是为了在进行编辑和查看切换的时候，新增按钮动画效果，在当前位置进行透明度的隐藏或显示。
            // 如果不用HStack和Spacer，切换时的效果，是添加按钮，从右边移动到中间，在这个过程中隐藏。
            HStack {
                Spacer()
                addButton
                    .scaleEffect(isEditing ? 0 : 1)
                    .opacity(isEditing ? 0 : 1)
                    .animation(.easeInOut, value: isEditing)
            }
        }
    }
    
    func buildNutritionView(title: String, value: String) -> some View {
        GridRow {
            Text(title).gridCellAnchor(.leading)
            Text(value).gridCellAnchor(.trailing)
        }
    }
}

#Preview {
    FoodListView()
    // 在当前预览页注入环境变量editMode，使用constant赋值.active
//    FoodListView().environment(\.editMode, .constant(.active))
//    FoodListView().environment(\.dynamicTypeSize, .accessibility1)
}
