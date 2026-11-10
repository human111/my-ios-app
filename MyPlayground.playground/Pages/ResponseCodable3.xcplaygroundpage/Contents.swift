import Foundation



// 手动模拟后端数据源
let data = Data("""
{
    "status": 200,
    "quota": 100,
    "response": [
        {"id": 13, "firstName": "ghy", "lastName": "letv"},
        {"id": 1, "firstName": "ghy", "lastName": "fintopia"}
    ]
}
""".utf8)

// 假设这是后端返回的数据结构
struct Response<T: Decodable>: Decodable {
    var status: Int
    var quota: Int
    var response: T
}

// iOS侧需要的字段
struct User: Decodable {
    var id: Int
    var name: String
    
    enum CodingKeys: CodingKey {
        case id, firstName, lastName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName  = try container.decode(String.self, forKey: .lastName)
        self.name = "\(firstName) \(lastName)"
    }
}

let response:Response<[User]> = try! JSONDecoder().decode(Response.self, from: data)
let demo2 = response.response
// [__lldb_expr_98.User(id: 13, name: "Jane Chao"), __lldb_expr_98.User(id: 1, name: "Teddy Lin")]
print("demo2---->: \(demo2)")

