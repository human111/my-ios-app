#  View的大小类型Hugging、Netural、Expanding

先说明一点：SwiftUI 官方并没有 **Hugging / Neutral / Expanding** 这三个术语（Hugging 来自 UIKit 的 Content Hugging Priority）。但用它们来归类 SwiftUI 视图的尺寸行为非常贴切，下面按这个思路讲。

## 先理解 SwiftUI 的布局规则

三步协商：

1. **父视图**给子视图一个**建议尺寸**（proposed size）
2. **子视图**根据建议尺寸和自身情况，**决定**自己的尺寸
3. 父视图把子视图**摆放**在合适位置

三种类型的区别，就在于第 2 步子视图怎么回应建议尺寸。

## 1. Hugging（包裹型）

**行为**：只取自己内容需要的尺寸，父视图给再大的空间也不会变大。

**典型视图**：`Text`、`Button`、`Label`、非 resizable 的 `Image`、`Image(systemName:)`、圆形 `ProgressView`

```swift
VStack {
    Text("登录")
        .background(Color.blue)   // 蓝色背景刚好包住文字
    
    Image(systemName: "star.fill")  // 保持自身固有尺寸
}
.frame(width: 300, height: 300)
.background(Color.gray.opacity(0.2)) // 父容器很大，子视图仍然很小
```

**细节**：`Text` 在空间不足时会先换行，再截断（`...`）。想让它无视建议尺寸、始终按完整内容显示，用 `.fixedSize()`：

```swift
Text("这是一段很长很长的文字")
    .frame(width: 50)
    .fixedSize(horizontal: false, vertical: true) // 宽度固定 50，高度按内容自动撑开
```

## 2. Expanding（扩展型）

**行为**：尽可能占满父视图给出的建议尺寸。

**典型视图**：

| 视图 | 扩展方向 |
|---|---|
| `Color`、`Rectangle`、`Circle`、`RoundedRectangle` 等 Shape | 水平 + 垂直 |
| `Spacer` | 沿所在 Stack 的主轴 |
| `Divider` | 沿垂直于分割线的方向（水平 Stack 中是竖线，纵向扩展） |
| `Image` + `.resizable()` | 水平 + 垂直 |
| `GeometryReader`、`ScrollView`、`List`、`Map` | 水平 + 垂直 |
| `TextField`、`Slider` | 仅水平 |
| `.frame(maxWidth: .infinity)` 修饰的视图 | 按设置的方向 |

```swift
VStack {
    Color.orange            // 占满整个屏幕剩余空间
    Text("底部文字")
}
```

```swift
// Shape 占满建议尺寸；圆形取较短边
Circle()
    .fill(.green)
    .frame(width: 200, height: 100) // 实际直径 100
```

**把 Hugging 变成 Expanding**：

```swift
Text("标题")
    .frame(maxWidth: .infinity, alignment: .leading) // 宽度撑满，文字靠左
    .background(Color.yellow)
```

## 3. Neutral（中性型）

**行为**：自己没有固定的尺寸偏好，**大小取决于子视图**：子视图包裹，它就包裹；子视图扩展，它就扩展。

**典型视图**：

- 容器：`HStack`、`VStack`、`ZStack`
- 大部分修饰符：`.padding()`、`.background()`、`.overlay()`、`.border()`、`.opacity()`、`.shadow()`、`.foregroundColor()` 等

```swift
// 子视图是 Hugging → 整体 Hugging
Text("Hi")
    .padding()
    .background(Color.red)       // 红色块刚好包住带内边距的文字

// 子视图是 Expanding → 整体 Expanding
Color.red
    .padding()                   // 占满全屏，只是四周留白
```

Stack 的规则：**只要有一个子视图在主轴方向上是 Expanding，整个 Stack 在该方向上就是 Expanding**。

```swift
HStack {
    Text("A")
    Text("B")
}   // Hugging：宽度 = A + B + 间距

HStack {
    Text("A")
    Spacer()
    Text("B")
}   // Expanding：Spacer 撑满，A 靠左 B 靠右
```

**常见坑**：`.background` 和 `.overlay` 是 Neutral 的，它们**跟随主视图**的尺寸，自己不会撑大主视图：

```swift
Text("Hi").background(Color.red)         // 红色只有文字大小
ZStack { Color.red; Text("Hi") }         // 红色占满全屏，因为 Color 是 Expanding
```

## 对比总结

| 类型 | 尺寸由谁决定 | 父容器变大时 | 代表 |
|---|---|---|---|
| Hugging | 自身内容 | 不变 | Text、Button、Image |
| Expanding | 父视图建议尺寸 | 跟着变大 | Color、Shape、Spacer、ScrollView |
| Neutral | 子视图 | 看子视图类型 | Stack、padding、background |

## 切换类型的常用工具

```swift
.fixedSize()                              // 任何视图 → Hugging（用理想尺寸，忽略建议尺寸）
.frame(width: 44, height: 44)             // → 固定尺寸（对外表现为 Hugging 一个固定值）
.frame(maxWidth: .infinity)               // → 水平 Expanding
.layoutPriority(1)                        // 空间不够时，优先级高的先拿空间
.scaledToFit() / .aspectRatio(...)        // 控制 Expanding 视图的宽高比
```

## 综合示例：聊天输入栏

```swift
HStack(spacing: 8) {
    Button { } label: {
        Image(systemName: "face.smiling")   // Hugging
    }

    TextField("输入消息", text: $text)       // 水平 Expanding，占满剩余宽度
        .textFieldStyle(.roundedBorder)

    Button("发送") { }                       // Hugging，宽度随文字
}
.padding(.horizontal)                        // Neutral，仅添加边距
```

整行最终水平方向是 Expanding（因为包含 TextField），表情和发送按钮保持自身大小，输入框吃掉所有剩余空间。

**多个 Expanding 视图争夺空间时**：默认平分；用 `.layoutPriority` 可以让某个视图先拿；需要按比例分配时，可用 `GeometryReader` 或 iOS 16+ 的自定义 `Layout` 协议。
