import Foundation

// 假设这是后端返回的字段
//struct Response: Decodable {
//    var id: Int
//    var firstName: String
//}

// 手动后端数据源
let data = Data("""
{"first_Name": "ghy", "last_Name": "letv"}
""".utf8)

// iOS侧需要的字段
struct User: Codable {
    var firstName: String
    var lastName: String
}


// Codable: Decodable & Encodable，两个都遵守
//extension User: Codable {
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_Name"
//        case lastName = "last_Name"
//    }
//}

//let demo2 = try! JSONDecoder().decode(User.self, from: data)
//print("demo2---->: \(demo2)")
//
//let tmepEncodeData = try! JSONEncoder().encode(demo2)
//let demo3 = String(data: tmepEncodeData, encoding: .utf8)!
//print("demo3---->: \(demo3)")

//
// 用keyDecodingStrategy && keyEncodingStrategy的写法 替换 Codingkey的写法
let tempDecoder = JSONDecoder()
tempDecoder.keyDecodingStrategy = .convertFromSnakeCase
let demo2 = try! tempDecoder.decode(User.self, from: data)
print("demo2---->: \(demo2)")

let tempEncoder = JSONEncoder()
tempEncoder.keyEncodingStrategy = .convertToSnakeCase
let tmepEncodeData = try! tempEncoder.encode(demo2)
let demo3 = String(data: tmepEncodeData, encoding: .utf8)!
print("demo3---->: \(demo3)")
