import Foundation

// 假设这是后端返回的字段
struct Response: Decodable {
    var id: Int
    var firstName: String
}

// 手动转换
let data = Data("""
{"id": 13, "firstName": "ghy"}
""".utf8)
let demo1 = try! JSONDecoder().decode(Response.self, from: data)
print("demo1---->: \(demo1)")

// iOS侧需要的字段
struct User {
    var id: Int
    var name: String
}


// Decodable解码：外部数据 → Swift 对象
extension User: Decodable {
    enum CodingKeys: CodingKey {
        case id, firstName
    }
    
    init(from decoder: Decoder) throws {
        // 将后端返回的数据包装成swift对象
        // 1、建立一个Container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 2、透过CodingKey，从Container中拿到对应的数据
        // 3、把数据放入swift定义的属性中（User）
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .firstName)
    }
}

let demo2 = try! JSONDecoder().decode(User.self, from: data)
print("demo2---->: \(demo2)")

// Encodable编码：Swift 对象 → 外部数据
extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .firstName)
    }
}

let tmepEncodeData = try! JSONEncoder().encode(demo2)
// 尾部没有加上！，Optional("{\"id\":13,\"firstName\":\"ghy\"}")
//let demo3 = String(data: tmepEncodeData, encoding: .utf8)
// 加上！{"id":13,"firstName":"ghy"}
let demo3 = String(data: tmepEncodeData, encoding: .utf8)!
print("demo3---->: \(demo3)")
