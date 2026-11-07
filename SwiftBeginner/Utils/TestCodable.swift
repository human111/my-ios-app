//
//  TestCodable.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/7.
//

import Foundation

// 测试自动生成Codable代码demo
struct TestCodable: Codable {
    var name: String
    var age: Int
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TestCodable.CodingKeys> = try decoder.container(keyedBy: TestCodable.CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: TestCodable.CodingKeys.name)
        self.age = try container.decode(Int.self, forKey: TestCodable.CodingKeys.age)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<TestCodable.CodingKeys> = encoder.container(keyedBy: TestCodable.CodingKeys.self)
        
        try container.encode(self.name, forKey: TestCodable.CodingKeys.name)
        try container.encode(self.age, forKey: TestCodable.CodingKeys.age)
    }
}
