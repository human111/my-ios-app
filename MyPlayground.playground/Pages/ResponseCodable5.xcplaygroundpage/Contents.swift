// 针对ResponseCodable4的优化
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
//        self.id = try container.decode(Int.self, forKey: .id)
//        
//        let firstName = try container.decode(String.self, forKey: .firstName)
//        let lastName  = try container.decode(String.self, forKey: .lastName)
        
        self.id = try container[.id]
        
        // 换成这种写法后，需要明确指定对应的类型
        let firstName: String = try container[.firstName]
        let lastName: String  = try container[.lastName]
        self.name = "\(firstName) \(lastName)"
        
        var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)

//        var ids = [Int]()
//        while !friendContainer.isAtEnd {
//            let friendIDContainer = try friendContainer.nestedContainer(keyedBy:
//                FriendIDContainerCodingKeys.self)
//            ids.append(try friendIDContainer[.id])
//        }
//        self.friendID = ids
        
//        self.friendID = try friendContainer.map { container -> Int in
//            let friendIDContainer = container.nestedContainer(keyedBy: FriendIDContainerCodingKeys.self)
//            return try friendIDContainer[.id]
//        }
        
//        self.friendID = try friendContainer.map { decoder -> Int in
//            let friendIDContainer = try decoder.container(keyedBy: FriendIDContainerCodingKeys.self)
//            return try friendIDContainer[.id]
//        }
        // 上面的简写
        self.friendID = try friendContainer.map {
            try $0.container(keyedBy: FriendIDContainerCodingKeys.self)[.id]
        }
    }
}

// 重新KeyedDecodingContainerProtocol下标的方法，加上这段后，上面init中的取值方法就可以变成那样简洁的写法
extension KeyedDecodingContainerProtocol {
    subscript<T: Decodable>(_ key: Key) -> T {
        get throws {
            try self.decode(T.self, forKey: key)
        }
    }
}

// 优化上面的while写法
extension UnkeyedDecodingContainer {
//    mutating func map<T>(_ transform: (UnkeyedDecodingContainer) throws -> T) rethrows -> [T] {
//        var item = [T]()
//        while !self.isAtEnd {
//            let item = try transform(self)
//            item.append(item)
//        }
//        
//        return items
//    }
    mutating func map<T>(_ transform: (Decoder) throws -> T) throws -> [T] {
        var items = [T]()
        while !self.isAtEnd {
            let item = try transform(superDecoder())
            items.append(item)
        }
        
        return items
    }
}

let response = try! JSONDecoder().decode(Response.self, from: data)
let demo2 = response.response
// [__lldb_expr_98.User(id: 13, name: "Jane Chao"), __lldb_expr_98.User(id: 1, name: "Teddy Lin")]
print("demo2---->: \(demo2)")
