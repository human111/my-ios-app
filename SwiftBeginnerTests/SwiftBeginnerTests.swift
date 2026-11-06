//
//  SuffixTests.swift
//  SuffixTests
//
//  Created by ghy on 2026/11/6.
//

import XCTest
@testable import SwiftBeginner

// cmd + U 运行测试
final class SuffixTests: XCTestCase {

    override func setUpWithError() throws {
        print(#function)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        print(#function)
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var sut: Suffix!

    // 命名格式：test_主题_情况_结果
    func testJoinNumberAndSuffix() throws {
        // 标准分三步走的原则写法：设定、变化、结果
        // Arrange 设定
        sut = .init(Suffix(wrappedValue: 100, ""))
        // Act 变化
        let result = sut.projectedValue
        // Result 结果
        XCTAssertEqual(result, "100", "没有单位时，不应该有空白位")
        
        sut = .init(Suffix(wrappedValue: 100.6, "大卡"))
        XCTAssertEqual(sut.projectedValue, "100.6 大卡")
    }
    
    func testNumberFormatter() throws {
        sut = .init(Suffix(wrappedValue: 100, "g"))
        XCTAssertEqual(sut.projectedValue, "100 g")
        
        sut = .init(Suffix(wrappedValue: 100.789, "g"))
        XCTAssertEqual(sut.projectedValue, "100.8 g", "应该在小数点第一位四舍五入")
        
        sut = .init(Suffix(wrappedValue: -100.789, "g"))
        XCTAssertEqual(sut.projectedValue, "-100.8 g")
        
        sut = .init(Suffix(wrappedValue: 100.711, "g"))
        XCTAssertEqual(sut.projectedValue, "100.7 g")
    }


}
