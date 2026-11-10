import Foundation



// 手动模拟后端数据源
let data = Data("""
{
    "status": 200,
    "quota": 100,
    "response": {
        "id": 13,
        "firstName": "ghy",
        "lastName": "letv",
        "friends":[
            {"id": 1},
            {"id": 8}
        ]
    }
}
""".utf8)

struct Response: Decodable {
    var response: User
}

struct User {
    var id: Int
    var name: String
    var friendID: [Int]
}

extension User: Decodable {
    enum CodingKeys: CodingKey {
        case id
        case firstName
        case lastName
        case friends
    }
    
    enum FriendIDContainerCodingKeys: CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName  = try container.decode(String.self, forKey: .lastName)
        self.name = "\(firstName) \(lastName)"
        
        var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)

        var ids = [Int]()
        while !friendContainer.isAtEnd {
            let friendIDContainer = try friendContainer.nestedContainer(keyedBy:
                FriendIDContainerCodingKeys.self)
//            let friendIDContainer = try friendContainer.nestedContainer(keyedBy: CodingKeys.self)
            ids.append(try friendIDContainer.decode(Int.self, forKey: .id))
        }
        self.friendID = ids
    }
}

let response = try! JSONDecoder().decode(Response.self, from: data)
let demo2 = response.response
// [__lldb_expr_98.User(id: 13, name: "Jane Chao"), __lldb_expr_98.User(id: 1, name: "Teddy Lin")]
print("demo2---->: \(demo2)")
