//
//  SuffixTests.swift
//  SuffixTests
//
//  Created by ghy on 2026/11/6.
//

import XCTest
@testable import SwiftBeginner
import SwiftUI

// 建立测试文件私有的变量
private let store = UserDefaults(suiteName: #file)!

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
    
    var sut: Suffix<WeightUnit>! = .init(wrappedValue: .zero, .defaultUnit, store: store)
    @AppStorage(.preferredWeightUnit, store: store) var preferredUnit: WeightUnit
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: #file)
//        preferredUnit = .gram
    }

    // 命名格式：test_主题_情况_结果
    func testJoinNumberAndSuffix() throws {
//        // 标准分三步走的原则写法：设定、变化、结果
//        // Arrange 设定
//        sut = .init(Suffix(wrappedValue: 100, ""))
//        // Act 变化
//        let result = sut.projectedValue
//        // Result 结果
//        XCTAssertEqual(result, "100", "没有单位时，不应该有空白位")
        
        sut = .init(Suffix(wrappedValue: 100.6, .gram))
        XCTAssertEqual(sut.projectedValue.description, "100.6 grams")
    }
    
    func testNumberFormatter_preferredPounds() {
        preferredUnit = .pound
        // 不用進位
        sut.wrappedValue = 100
        sut.unit = .gram
        XCTAssertEqual(sut.description, "0.2 pounds")

        // 要進位
        sut.wrappedValue = -300
        sut.unit = .gram
        XCTAssertEqual(sut.description, "-0.7 pounds")

        // 整數
        sut.wrappedValue = 453.592
        sut.unit = .gram
        XCTAssertEqual(sut.description, "1 pounds")
    }
    
    func testNumberFormatter() throws {
//        sut = .init(Suffix(wrappedValue: 100, .gram))
//        XCTAssertEqual(sut.description, "100 grams")
//        
//        sut = .init(Suffix(wrappedValue: 100.789, .gram))
//        XCTAssertEqual(sut.description, "100.8 grams", "应该在小数点第一位四舍五入")
//        
//        sut = .init(Suffix(wrappedValue: -100.789, .gram))
//        XCTAssertEqual(sut.description, "-100.8 grams")
//        
//        sut = .init(Suffix(wrappedValue: 100.711, .gram))
//        XCTAssertEqual(sut.description, "100.7 grams")
        
        sut.wrappedValue = 100
        sut.unit = .gram
        XCTAssertEqual(sut.description, "100 grams")

        sut.wrappedValue = 100.678
        sut.unit = .gram
        XCTAssertEqual(
            sut.description,
            "100.7 grams",
            "應該要在小數點第一位四捨五入"
        )

        sut.wrappedValue = -100.678
        sut.unit = .gram
        XCTAssertEqual(sut.description, "-100.7 grams")

        sut.wrappedValue = 100.7111
        sut.unit = .gram
        XCTAssertEqual(sut.description, "100.7 grams")
    }


}
