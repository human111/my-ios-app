// 针对ResponseCodable5中
/**
 针对ResponseCodable5中这段代码的写法优化
 self.friendID = try friendContainer.map {
     try $0.container(keyedBy: FriendIDContainerCodingKeys.self)[.id]
 }
 
 变成：
 try $0.container()["id"]
 */

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
    
//    enum FriendIDContainerCodingKeys: CodingKey {
//        case id
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container[.id]
        
        // 换成这种写法后，需要明确指定对应的类型
        let firstName: String = try container[.firstName]
        let lastName: String  = try container[.lastName]
        self.name = "\(firstName) \(lastName)"
        
        var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)
        // 上面的简写
        self.friendID = try friendContainer.map {
//            try $0.container(keyedBy: FriendIDContainerCodingKeys.self)[.id]
            // 不需要告诉container用的什么Key，直接给它一个String
            try $0.container()["id"]
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
    mutating func map<T>(_ transform: (Decoder) throws -> T) throws -> [T] {
        var items = [T]()
        while !self.isAtEnd {
            let item = try transform(superDecoder())
            items.append(item)
        }
        
        return items
    }
}

struct DecodingKey: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        return nil
    }
}

extension DecodingKey: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.stringValue = value
    }
}

// 重写Decoder中的container方法
extension Decoder {
    func container() throws -> KeyedDecodingContainer<DecodingKey> {
        try self.container(keyedBy: DecodingKey.self)
    }
}




let response = try! JSONDecoder().decode(Response.self, from: data)
let demo2 = response.response
// [__lldb_expr_98.User(id: 13, name: "Jane Chao"), __lldb_expr_98.User(id: 1, name: "Teddy Lin")]
print("demo22---->: \(demo2)")
