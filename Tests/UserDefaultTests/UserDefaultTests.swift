import XCTest
@testable import UserDefault

class UserData {

    @UserDefaultsStored(key: "kTestFalseBool")
    static var testFalseBool: Bool = false

    @UserDefaultsStored(key: "kTestTrueBool")
    static var testTrueBool: Bool = true

    @UserDefaultsStored(key: "kTestNullableBooll")
    static var testNullableBool: Bool?
    
    static func clear() {
        _testTrueBool.clear()
        _testFalseBool.clear()
        _testNullableBool.clear()
    }
}

final class UserDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserData.clear()
    }
    
    func testDefault() {
        XCTAssertFalse(UserData.testFalseBool)
        XCTAssertTrue(UserData.testTrueBool)
    }
    
    func testSet() {
        UserData.testFalseBool = true
        XCTAssertTrue(UserData.testFalseBool)
    }
    
    func testClear() {
        UserData.testNullableBool = false
        UserData.testFalseBool = true

        UserData.clear()
        
        XCTAssertFalse(UserData.testFalseBool)
        XCTAssertEqual(UserData.testNullableBool, nil)
    }
    
    func testNullableDefault() {
        XCTAssertEqual(UserData.testNullableBool, nil)
    }

    func testNullable() {
        UserData.testNullableBool = false
        XCTAssertEqual(UserData.testNullableBool, false)
    }
    
    static var allTests = [
        ("testDefault", testDefault),
        ("testSet", testSet),
        ("testClear", testClear),
        ("testNullableDefault", testNullableDefault),
        ("testNullable", testNullable),
    ]
}
