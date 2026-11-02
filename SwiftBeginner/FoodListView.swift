//
//  FoodListView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/27.
//

import SwiftUI

private enum Sheet: View, Identifiable {
    case newFood((Food) -> Void)
    case editFood(Binding<Food>)
    case foodDetail(Food)
    
    var id: UUID {
        switch self {
        case .newFood:
            return UUID()
        case .editFood(let binding):
            return binding.wrappedValue.id
        case .foodDetail(let food):
            return food.id
        }
    }
    
    var body: some View {
        switch self {
            case .newFood(let onSubmit):
                FoodListView.FoodForm(food: .new, onSubmit: onSubmit)
            case .editFood(let binding):
                FoodListView.FoodForm(food: binding.wrappedValue) {
                    binding.wrappedValue = $0
                }
            case .foodDetail(let food):
                FoodListView.FoodDetailSheet(food: food)
        }
    }
}

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @State private var foods = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    
    @State private var sheet: Sheet?
    
    var isEditing: Bool { editMode?.wrappedValue == .active }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleBar
            
            // 这里因为$food是Binding，在用“food in”遍历的时候，要使用wrappedValue才能获取到对象的值
            // 如果不想使用wrappedValue，可以用“$food in”的写法
            List($foods, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRaw)
            .listStyle(.plain)
            .padding(.horizontal)
            
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(item: $sheet) { $0 }
    }
}

private extension FoodListView {
    struct FoodDetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 300
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct FoodDetailSheet: View {
        @Environment(\.dynamicTypeSize) private var textSize
        @State private var foodDetailHeight: CGFloat = FoodDetailSheetHeightKey.defaultValue
        
        let food: Food
        
        var body: some View {
            // 根据不同的条件，来显示不通的布局（可以理解为动态布局）
            let shouldUseVStack = textSize.isAccessibilitySize || food.image.count > 1
            AnyLayout.useVStack(if: shouldUseVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(shouldUseVStack ? 1 : 0.5)
                
                Grid(horizontalSpacing: 30, verticalSpacing: 12) {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                    
                }
            }
            .padding()
            .padding(.vertical)
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height)
                }
            }
            .onPreferenceChange(FoodDetailSheetHeightKey.self) {
                foodDetailHeight = $0
            }
            .presentationDetents([.height(foodDetailHeight)])
        }
        
        func buildNutritionView(title: String, value: String) -> some View {
            GridRow {
                Text(title).gridCellAnchor(.leading)
                Text(value).gridCellAnchor(.trailing)
            }
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
        Button {
            sheet = .newFood { foods.append($0) }
        } label: {
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
                foods = foods.filter { !selectedFoodID.contains($0.id) }
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
                    .scaleEffect(isEditing ? 0.001 : 1)
                    .opacity(isEditing ? 0 : 1)
                    .animation(.easeInOut, value: isEditing)
            }
        }
    }
    
    func buildFoodRaw(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name).padding(.vertical, 10)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing { return }
                    sheet = .foodDetail(food)
                }
            
            if isEditing {
                Image(systemName: "pencil")
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

#Preview {
    FoodListView()
    // 在当前预览页注入环境变量editMode，使用constant赋值.active
//    FoodListView().environment(\.editMode, .constant(.active))
//    FoodListView().environment(\.dynamicTypeSize, .accessibility1)
}
