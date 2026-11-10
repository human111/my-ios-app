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
//let demo1 = try! JSONDecoder().decode(Response.self, from: data)
//print("demo1---->: \(demo1)")

// iOS侧需要的字段
struct User {
    var id: Int
    var name: String
}


// Codable: Decodable & Encodable，两个都遵守
extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "firstName"
    }
}

let demo2 = try! JSONDecoder().decode(User.self, from: data)
print("demo2---->: \(demo2)")

let tmepEncodeData = try! JSONEncoder().encode(demo2)
let demo3 = String(data: tmepEncodeData, encoding: .utf8)!
print("demo3---->: \(demo3)")
