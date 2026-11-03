# 错误集1

主要用来记录开发中遇到的一些问题

## ForEach中，为啥有时需要使用id，不写就是错误提示

### 原因

`ForEach` 需要给每个元素一个**唯一标识**，这样数据增删、重排时 SwiftUI 才知道哪个视图对应哪个数据，才能正确刷新和做动画。

`me.skills` 是 `[String]`（字符串数组），而 `String` **没有遵循 `Identifiable`**，没有 `id` 属性，SwiftUI 不知道用什么当标识。所以要用 `id:` 告诉它。

### `\.self` 是什么意思

`\.self` 是一个 KeyPath，表示"**把元素本身当作 id**"。这里每个技能名字（"python"、"swift"……）自己就是标识：

```swift
ForEach(me.skills, id: \.self) { skill in ... }
```

### 对比

```swift
// 元素是 Identifiable，不用写 id
ForEach(foods) { food in ... }          // Food 遵循 Identifiable（你前面写过的）

// 元素不是 Identifiable（String、Int 等），必须写 id
ForEach(me.skills, id: \.self) { skill in ... }
```

### 使用 `id: \.self` 的前提：元素必须唯一

标识重复会出问题。比如：

```swift
let skills = ["swift", "swift", "python"]   // 有重复
```

重复的 id 会导致显示错乱、动画异常，控制台还会警告：`the ID swift occurs multiple times`。

- **元素不重复**（比如你的技能列表）：`id: \.self` 完全没问题。
- **元素可能重复**：改用下标，或者把数据包装成遵循 `Identifiable` 的结构体：

```swift
// 方式一：用下标当 id（数组固定不变时可用）
ForEach(me.skills.indices, id: \.self) { index in
    Text(me.skills[index])
}

// 方式二：包装成模型（更推荐）
struct Skill: Identifiable {
    let id = UUID()
    let name: String
}
```

### 为什么不写会报错

不写 `id:` 时，编译器会提示类似 `Generic struct 'ForEach' requires that 'String' conform to 'Identifiable'`，就是在说 `String` 没有 `id`，需要你手动指定。


## 书写闭包时，报错

这个报错的原因是：你把闭包的类型 `(Food) -> Void` 写成了闭包的实际值。

你的代码：

```
#Preview {
    FoodListView.FoodForm(
        food: Food.examples.first!,
        onSubmit: (Food) -> Void
    )
}
```

`(Food) -> Void` 表示一个函数类型，而 `onSubmit` 参数需要的是一个实际的闭包。

### 1. 最简单的修改方式

如果 Preview 只是用来预览界面，不需要执行提交逻辑，可以传入一个空闭包：

```
#Preview {
    FoodListView.FoodForm(
        food: Food.examples.first!,
        onSubmit: { _ in }
    )
}
```

其中：

```
{ _ in }
```

表示接收一个 `Food` 参数，但是不使用它，也不执行任何操作。

### 2. 如果想查看提交的数据

可以这样写：

```
#Preview {
    FoodListView.FoodForm(
        food: Food.examples.first!,
        onSubmit: { food in
            print("提交食物：\(food)")
        }
    )
}
```

这样点击提交时，就会执行闭包中的代码。

### 3. 为什么不能直接写 `(Food) -> Void`？

假设你的 View 定义如下：

```
struct FoodForm: View {
    let food: Food
    let onSubmit: (Food) -> Void

    var body: some View {
        Button("提交") {
            onSubmit(food)
        }
    }
}
```

这里：

```
let onSubmit: (Food) -> Void
```

表示 `onSubmit` 的类型是一个接收 `Food` 并且没有返回值的函数。

而：

```
onSubmit: { food in
    print(food)
}
```

才是一个实际的函数值。

可以理解为：

| 写法                        | 含义   |
| ------------------------- | ---- |
| `(Food) -> Void`          | 函数类型 |
| `{ food in print(food) }` | 实际闭包 |
| `{ _ in }`                | 空闭包  |

因此，你目前的 Preview 直接使用 `{ _ in }` 就可以解决问题。
