# Encodable && Decodable理解

`Decodable` 和 `Encodable` 是 Swift 标准库里的两个协议，合起来就是 `Codable`。它们分别负责“从外部数据还原成 Swift 对象”和“把 Swift 对象转成外部数据”。

### 一句话理解

- **`Encodable`**：Swift 对象 → 外部格式（如 JSON `Data`）。你之前用 `JSONEncoder().encode(user)` 时，`User` 遵守的就是它。
- **`Decodable`**：外部格式（如 JSON `Data`）→ Swift 对象。用 `JSONDecoder().decode(User.self, from: data)`。
- **`Codable`**：`typealias Codable = Decodable & Encodable`，两个都遵守。

### 方向对比

| 协议 | 方向 | 配合的类 | 方法 |
|---|---|---|---|
| `Encodable` | 对象 → 数据 | `JSONEncoder` | `encode(_:)` |
| `Decodable` | 数据 → 对象 | `JSONDecoder` | `decode(_:from:)` |

### 代码示例

```swift
import Foundation

struct User: Codable {   // 等价于 Decodable & Encodable
    var name: String
    var age: Int
}

// Encodable：对象 → Data
let user = User(name: "ghy", age: 25)
let data = try! JSONEncoder().encode(user)
// data 内容: {"name":"ghy","age":25}

// Decodable：Data → 对象
let decoded = try! JSONDecoder().decode(User.self, from: data)
print(decoded.name) // ghy
```

### 什么时候只用一个？

- **只需要解析服务器返回**：只声明 `Decodable`，避免误把对象编码出去。
- **只需要上传数据**：只声明 `Encodable`。
- **两者都要**：用 `Codable`。

### 自动合成的规则

只要所有存储属性本身都遵守 `Codable`（`String`、`Int`、`Array`、嵌套的 `Codable` 结构体等），编译器会自动合成 `init(from:)` 和 `encode(to:)`，你不用写任何代码。你之前的 `extension User: Encodable {}` 就是利用了这个自动合成。

### 常见需要手写的场景

**1. JSON 的 key 和属性名不一致**——用 `CodingKeys`：

```swift
struct User: Codable {
    var name: String
    var age: Int
    enum CodingKeys: String, CodingKey {
        case name = "user_name"
        case age
    }
}
```

**2. 缺失字段给默认值**——手写 `init(from:)`：

```swift
struct User: Decodable {
    var name: String
    var age: Int
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        age = try c.decodeIfPresent(Int.self, forKey: .age) ?? 0
    }
    enum CodingKeys: String, CodingKey { case name, age }
}
```

**3. 类型不一致**（服务器给字符串 `"25"` 但你要 `Int`）——同样手写 `init(from:)` 做转换。

### 和你之前用的 `JSONSerialization` 对比

- `Codable` + `JSONEncoder/Decoder`：类型安全、代码简洁，适合结构固定的模型，**现在的首选**。
- `JSONSerialization`：手动操作字典/数组，适合结构不固定或只取个别字段的场景。

### 一个小提醒

`try!` 在解析服务器数据时很危险，线上代码建议用 `do-catch` 或 `try?`：

```swift
do {
    let decoded = try JSONDecoder().decode(User.self, from: data)
    print(decoded)
} catch {
    print("解码失败: \(error)")
}
```

