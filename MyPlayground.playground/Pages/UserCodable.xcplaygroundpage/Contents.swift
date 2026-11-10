import Foundation

struct User {
    var name: String
    var age: Int
}

let user = User(name: "ghy", age: 18)

// 将User扩展成一个Encodable，来获取Data
extension User: Encodable {}

let data = try! JSONEncoder().encode(user)
print(String(data: data, encoding: .utf8)!)

// 使用JSONSerialization做转换
let jsonObj = try! JSONSerialization.jsonObject(with: data)
print("jsonObj---->: \(jsonObj)")

// JSONSerialization 双向转换
//let dictionary = jsonObj as! Dictionary<String, String>
let dictionary = jsonObj as! Dictionary<String, Any>
print("jsonObj Dictionary---->: \(dictionary)")

// 使用Decodable做转换
extension User: Decodable {}
let userJsonDecodable = try! JSONDecoder().decode(User.self, from: data)
print("userJsonDecodable---->: \(userJsonDecodable)")

