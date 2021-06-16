import XCTest
@testable import UserDefault

class UserData {

    @UserDefault("kTestFalseBool", defaultValue: false)
    static var testFalseBool: Bool

    @UserDefault("kTestTrueBool", defaultValue: true)
    static var testTrueBool: Bool

    @NullableUserDefault("kTestNullableBooll")
    static var testNullableBool: Bool?
    
    static func clean() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

final class UserDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        UserData.clean()
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
        
        UserData.clean()
        
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
