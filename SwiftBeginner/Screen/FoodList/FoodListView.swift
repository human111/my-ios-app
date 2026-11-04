//
//  FoodListView.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/27.
//

import SwiftUI

struct FoodListView: View {
//    @Environment(\.editMode) var editMode
    @State private var editMode: EditMode = .inactive
    @State private var foods = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    
    @State private var sheet: Sheet?
    
    var isEditing: Bool { editMode.isEditing }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleBar
            
            // 这里因为$food是Binding，在用“food in”遍历的时候，要使用wrappedValue才能获取到对象的值
            // 如果不想使用wrappedValue，可以用“$food in”的写法
            List($foods, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRaw)
            .listStyle(.plain)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.groupBg2)
                    .ignoresSafeArea(.container, edges: .bottom)
            }
            .padding(.horizontal)
            
        }
        .background(.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .environment(\.editMode, $editMode)
        .sheet(item: $sheet)
    }
}

// MARK: FoodDetailSheet 拆分到单独的views文件夹中管理

// MARK: Sheet 拆分到单独的views文件夹中管理

// MARK: Subviews
private extension FoodListView {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: .forkAndKnife)
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
            
            EditButton().buttonStyle(.bordered)
            
            addButton
        }.padding()
    }
    
    var addButton: some View {
        Button {
            sheet = .newFood { foods.append($0) }
        } label: {
            SFSymbol.plus
                .font(.system(size: 40))
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
                .padding(.bottom)
            
            // 这样写，是为了在进行编辑和查看切换的时候，新增按钮动画效果，在当前位置进行透明度的隐藏或显示。
            // 如果不用HStack和Spacer，切换时的效果，是添加按钮，从右边移动到中间，在这个过程中隐藏。
//            HStack {
//                Spacer()
//                addButton
//                    .scaleEffect(isEditing ? 0.001 : 1)
//                    .opacity(isEditing ? 0 : 1)
//                    .animation(.easeInOut, value: isEditing)
//            }
            // 添加按钮移动到编辑按钮旁边了
//            addButton
//                .scaleEffect(isEditing ? 0.001 : 1)
//                .opacity(isEditing ? 0 : 1)
//                .animation(.easeInOut, value: isEditing)
//                .push(to: .trailing)
        }
    }
    
    func buildFoodRaw(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name)
                .font(.title3)
                .padding(.vertical, 10)
                .push(to: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing {
                        selectedFoodID.insert(food.id)
                        return
                    }
                    sheet = .foodDetail(food)
                }
            
            if isEditing {
                SFSymbol.pencil
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }.listRowBackground(Color.clear)
    }
}

// MARK: Preview
#Preview {
    FoodListView()
    // 在当前预览页注入环境变量editMode，使用constant赋值.active
//    FoodListView().environment(\.editMode, .constant(.active))
//    FoodListView().environment(\.dynamicTypeSize, .accessibility1)
}
