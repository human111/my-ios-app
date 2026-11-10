# JSONSerialization常规用途

`JSONSerialization` 是 Foundation 框架里的一个核心类，专门用来在 **JSON 数据** 和 **Foundation 对象**（如字典、数组、字符串、数字）之间做转换。它和你之前用的 `JSONEncoder` 是“同事”，但分工不同。

### 核心用途：双向转换

它主要做两件事：

1.  **把 JSON 变成 Foundation 对象（解析/反序列化）**：当你从网络或文件拿到一段 `Data` 类型的 JSON 数据时，用它转换成 Swift 里可以直接操作的 `[String: Any]` 或 `[Any]`。
2.  **把 Foundation 对象变成 JSON 数据（生成/序列化）**：当你需要把字典或数组发给服务器时，用它转换成 `Data` 格式。

### 关键方法与使用示例

它主要依赖两个静态方法，且都需要用 `try` 配合 `do-catch` 处理错误。

**1. 解析 JSON：`jsonObject(with:options:)`**
把 `Data` 转成字典或数组。

```swift
let jsonString = """
{"name": "ghy", "age": 25}
"""
if let data = jsonString.data(using: .utf8) {
    do {
        // 解析为字典
        if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print(dict["name"] as? String ?? "") // 输出 ghy
        }
    } catch {
        print("解析失败: \(error)")
    }
}
```

**2. 生成 JSON：`data(withJSONObject:options:)`**
把字典或数组转成 `Data`。

```swift
let dict: [String: Any] = ["name": "ghy", "age": 25]
do {
    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
    // 如果需要字符串形式方便查看
    print(String(data: data, encoding: .utf8) ?? "")
} catch {
    print("生成失败: \(error)")
}
```

### 它能处理哪些对象？（重要限制）

并非所有 Swift 对象都能直接扔给它。传入的 Foundation 对象必须满足以下条件：

*   **顶层对象**必须是 `NSArray` 或 `NSDictionary`（除非你开启了 `fragmentsAllowed` 选项）。
*   所有元素必须是 `NSString`、`NSNumber`、`NSArray`、`NSDictionary` 或 `NSNull`。
*   字典的键必须是 `NSString`。
*   数字不能是 `NaN` 或无穷大。

如果你不确定某个对象能不能转，可以先用 `JSONSerialization.isValidJSONObject(_:)` 检查一下，它会返回一个布尔值。

### 和你用过的 `JSONEncoder` 有什么区别？

既然你之前用了 `JSONEncoder` 来编码 `User` 结构体，这里简单对比一下：

*   **`JSONSerialization`**：更底层、更灵活。它不关心你的 Swift 类型长什么样，只认字典/数组这种“原始”结构。适合处理结构不固定、或者你只想手动取几个字段的 JSON（比如只从一大段 JSON 里抠出 `name`）。
*   **`JSONEncoder` / `JSONDecoder`**：更现代、更安全。它配合 `Codable` 协议，直接把 JSON 映射成你定义好的结构体（如 `User`）。类型安全，代码也更简洁，是现在的首选方式。

### 一个实际应用场景

在网络请求中，如果你不想为每个接口都写一个 `Codable` 结构体，或者响应的结构变化很大，`JSONSerialization` 就很方便。你可以直接把返回的 `Data` 转成字典，按需取值，避免写一大堆模型文件。
