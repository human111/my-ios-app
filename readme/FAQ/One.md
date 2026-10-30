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
