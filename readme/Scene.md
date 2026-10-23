#  Scene

这三个都是遵守 `Scene` 协议的类型，区别在于它们**管理的是哪一种界面**。

## 1. WindowGroup

**含义**：管理一组"同类型的普通窗口"，是最通用的场景。

**特点**：
- iPhone 上：就是应用的主界面。
- iPad：支持多窗口（Split View、Stage Manager），每个窗口都是一个独立的 `WindowGroup` 实例。
- Mac：用户可以按 ⌘N 新开窗口，每个窗口各自拥有独立的状态。
- visionOS：同样支持多窗口。

**使用场景**：几乎所有 App，如习惯追踪、社交、电商、工具类。

```swift
@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**进阶**：可以给窗口加标识，方便用代码打开特定窗口（Mac / iPad）：

```swift
WindowGroup("习惯详情", id: "detail") {
    DetailView()
}
```

## 2. DocumentGroup

**含义**：管理"基于文档的应用"，每个窗口对应**一个文件**。系统会自动处理文件的新建、打开、保存、另存为、最近文档等一整套行为。

**特点**：
- 启动时（iOS）会显示系统的文件浏览器，Mac 上则是打开/新建文档的面板。
- 自动支持 iCloud Drive、文件 App、撤销重做、自动保存。
- 需要你定义文档类型（遵守 `FileDocument` 或 `ReferenceFileDocument`，SwiftData 也支持 `DocumentGroup(editing:contentType:)`）。

**使用场景**：文本编辑器、绘图工具、笔记、表格、思维导图、代码编辑器等，**用户需要自己管理文件**的应用。

```swift
@main
struct TextEditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MyDocument()) { file in
            EditorView(document: file.$document)
        }
    }
}
```

**对比**：习惯追踪这类 App 数据存在 App 内部的数据库里，用户不需要"打开某个文件"，所以用 `WindowGroup` 而不是 `DocumentGroup`。

## 3. Settings

**含义**：创建 **macOS 的"设置"窗口**（旧称"偏好设置"），用户通过菜单栏 **App 名 → 设置…**（快捷键 ⌘,）打开。

**特点**：
- **仅 macOS 可用**，iOS 的设置要么做在 App 内的页面里，要么放到系统"设置"App 中。
- 系统自动在菜单栏生成"设置…"菜单项并绑定快捷键，你不用手动处理。
- 通常配合 `TabView` 做成多标签页的设置界面。

**使用场景**：Mac 应用中的偏好选项，如通用、外观、账号、快捷键等。

```swift
@main
struct MyMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        #if os(macOS)
        Settings {
            TabView {
                GeneralSettingsView()
                    .tabItem { Label("通用", systemImage: "gear") }
                AppearanceSettingsView()
                    .tabItem { Label("外观", systemImage: "paintbrush") }
            }
            .frame(width: 400, height: 300)
        }
        #endif
    }
}
```

注意跨平台项目要用 `#if os(macOS)` 包起来，否则在 iOS 上编译会报错。

## 对比总结

| 场景类型 | 管理的对象 | 平台 | 典型应用 |
|---|---|---|---|
| `WindowGroup` | 普通窗口 | 全平台 | 绝大多数 App |
| `DocumentGroup` | 文档文件窗口 | iOS / iPadOS / macOS / visionOS | 编辑器、绘图、笔记 |
| `Settings` | 设置窗口 | 仅 macOS | Mac App 的偏好设置 |

## 可以组合使用

一个 App 的 `body` 里可以同时放多个场景，比如 Mac 上常见的写法：

```swift
var body: some Scene {
    WindowGroup { ContentView() }   // 主窗口
    Settings { SettingsView() }     // 设置窗口
}
```

如果你的目标只是做 iPhone 上的习惯追踪 App，只用 `WindowGroup` 就够了。

