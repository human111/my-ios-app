//
//  FoodForm.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/2.
//

import SwiftUI

private enum MyField: Int {
    case title, image, calories, protein, fat, carb
}

private extension TextField where Label == Text {
    func focused(_ field: FocusState<MyField?>.Binding, equals this: MyField) -> some View {
        submitLabel(this == .carb ? .done : .next)
            .focused(field, equals: this)
            .onSubmit {
                field.wrappedValue = .init(rawValue: this.rawValue + 1)
            }
    }
}

extension FoodListView {
    struct FoodForm: View {
        @Environment(\.dismiss) var dismiss
        @FocusState private var field: MyField?
        @State var food: Food
        var onSubmit: (Food) -> Void
        
        private var isNotValid: Bool {
            food.name.isEmpty || food.image.count > 2
        }
        
        private var invalidMessage: String? {
            if food.name.isEmpty { return "请输入名称" }
            if food.image.count > 2 { return "图示数字过多" }
            return .none
        }
        
        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        Label("编辑食物资讯", systemImage: "pencil")
                            .font(.title.bold())
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                // 关闭打开的sheet
                                dismiss()
                            }
                    }.padding([.horizontal, .top])
                    
                    Form {
                        LabeledContent("名称") {
                            TextField("必填", text: $food.name)
                                .focused($field, equals: .title)
                        }
                        
                        LabeledContent("图示") {
                            TextField("最多输入2个字", text: $food.image)
                                .focused($field, equals: .image)
                        }
                        
                        buildNumberField(title: "热量", value: $food.calorie, field: .calories, suffix: "大卡")
                        buildNumberField(title: "蛋白质", value: $food.protein, field: .protein)
                        buildNumberField(title: "脂肪", value: $food.fat, field: .fat)
                        buildNumberField(title: "碳水", value: $food.carb, field: .carb)
                    }.padding(.top, -16)
                    
                    // 操作：保存按钮
                    Button {
                        dismiss()
                        onSubmit(food)
                    } label: {
                        Text(invalidMessage ?? "保存")
                            .bold()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    .mainButtonStyle()
                    .padding()
                    .disabled(isNotValid)
                }
                .background(.groupBg)
                .multilineTextAlignment(.trailing)
                .font(.title3)
                .scrollDismissesKeyboard(.interactively)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: goPreviousField) {
                            Image(systemName: "chevron.up")
                        }
                        
                        Button(action: goNextField) {
                            Image(systemName: "chevron.down")
                        }
                    }
            }
            }
        }
        
        func goPreviousField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue - 1)
        }
        
        func goNextField() {
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue + 1)
        }
        
        private func buildNumberField(
            title: String,
            value: Binding<Double>,
            field: MyField,
            suffix: String = "g"
        ) -> some View {
            
            LabeledContent(title) {
                HStack {
                    TextField(
                        "",
                        value: value,
                        format: .number.precision(.fractionLength(1))
                    )
                    .focused($field, equals: field)
                    .keyboardType(.decimalPad)
                    
                    Text(suffix)
                }
            }
        }
    }
}

#Preview {
    FoodListView.FoodForm(
        food: Food.examples.first!,
        onSubmit: { _ in }
    )
}
