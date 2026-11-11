//
//  CatImage+.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/11/11.
//

import SwiftUI
import Foundation

// 友好的错误提示
private struct MyUserFriendlyError: LocalizedError {
    var errorDescription: String?
    
    init?(errorDescription: String? = nil) {
        guard let errorDescription else { return nil }
        self.errorDescription = errorDescription
    }
}

// View扩展两个自定义的方法
extension View {
    func previewEnvironmentObject(manager: CatAPIManager = .preview) -> some View {
        environmentObject(manager)
    }
    
    func alert(errorMessage: Binding<String?>) -> some View {
        alert(isPresented: Binding(
            get: { errorMessage.wrappedValue != nil },
            set: { _ in errorMessage.wrappedValue = nil }
        ), error: MyUserFriendlyError(errorDescription: errorMessage.wrappedValue)) { }
    }
}

// URLSession扩展
extension URLSession {
    static var imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        return URLSession(configuration: config)
    }()
}

extension URLSession {
    // API错误枚举
    enum APIError: Error {
        case invalidURL
        case invalidData
        case invalidCode(Int)
    }
    
    
    func data(for urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw APIError.invalidURL }
        guard 200...299 ~= response.statusCode else {
            assertionFailure(String(data: data, encoding: .utf8) ?? "")
            throw APIError.invalidCode(response.statusCode)
            
        }
        return data
    }
}

// URLCache的扩展
extension URLCache {
    static let imageCache: URLCache = {
        URLCache(memoryCapacity: 20 * 1024 * 1024,
                 diskCapacity: 30 * 1024 * 1024,
                 directory: FileManager.default.temporaryDirectory)
    }()
}

// URL的扩展
extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self.init(string: value.description)!
    }
}

// DecodingKey的扩展
struct DecodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}


extension DecodingKey: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        stringValue = stringLiteral
    }
}

extension Decoder {
    func container() throws -> KeyedDecodingContainer<DecodingKey> {
        try self.container(keyedBy: DecodingKey.self)
    }
}

extension KeyedDecodingContainer {
    subscript<Value: Decodable>(_ key: Key) -> Value {
        get throws {
            try self.decode(Value.self, forKey: key)
        }
    }
    
    func nestedContainer(key: Key) throws -> KeyedDecodingContainer<DecodingKey> {
        try self.nestedContainer(keyedBy: DecodingKey.self, forKey: key)
    }
}
