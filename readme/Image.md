#  Image

在 SwiftUI 里，`Image` 默认按图片的**原始尺寸**显示，直接写 `.frame` 不会缩放图片本身，必须先加 `.resizable()`。

## 基本写法

```swift
Image("myPhoto")
    .resizable()
    .frame(width: 100, height: 100)
```

`.resizable()` 的作用是让图片可以被拉伸填满给定的空间。**顺序很重要**：`.resizable()` 必须写在 `.frame` 之前。

## 保持比例（最常用）

只用 `.resizable()` 加 `.frame` 会把图片拉变形。通常要加 `.scaledToFit()` 或 `.scaledToFill()`：

```swift
// 完整显示图片，保持比例，可能留空白
Image("myPhoto")
    .resizable()
    .scaledToFit()
    .frame(width: 200, height: 200)

// 填满区域，保持比例，超出部分会溢出，通常要配合裁剪
Image("myPhoto")
    .resizable()
    .scaledToFill()
    .frame(width: 200, height: 200)
    .clipped()
```

也可以用等价写法：`.aspectRatio(contentMode: .fit)` 或 `.aspectRatio(contentMode: .fill)`。

## 只指定一边

只设置宽度，高度会按比例自动计算：

```swift
Image("myPhoto")
    .resizable()
    .scaledToFit()
    .frame(width: 200)
```

## SF Symbols（系统图标）

系统图标是矢量图，不需要 `.resizable()`，用字体大小控制即可：

```swift
Image(systemName: "star.fill")
    .font(.system(size: 40))

// 或者用 imageScale
Image(systemName: "star.fill")
    .imageScale(.large)
```

如果想用 `.frame` 控制 SF Symbol 的大小，同样需要 `.resizable()` 和 `.scaledToFit()`：

```swift
Image(systemName: "star.fill")
    .resizable()
    .scaledToFit()
    .frame(width: 40, height: 40)
```

## 常见搭配：圆形头像

```swift
Image("avatar")
    .resizable()
    .scaledToFill()
    .frame(width: 80, height: 80)
    .clipShape(Circle())
```

## 总结

| 需求 | 写法 |
|---|---|
| 缩放图片 | `.resizable()` + `.frame(...)` |
| 保持比例完整显示 | 再加 `.scaledToFit()` |
| 保持比例填满 | 再加 `.scaledToFill()` + `.clipped()` |
| 调整 SF Symbol | `.font(.system(size:))` |

