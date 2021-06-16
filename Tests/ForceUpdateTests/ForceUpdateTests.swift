import XCTest
@testable import ForceUpdate

final class ForceUpdateTests: XCTestCase {
    
    func testExpressionEquality() {
        let version: Version = "1.2.4"

        XCTAssertTrue(version == Version("1.2.4"))
        XCTAssertFalse(version == Version("1.2.2"))
        XCTAssertFalse(version ==  Version("1.1.4"))
        XCTAssertFalse(version == Version("0.2.4"))
        XCTAssertFalse(version == Version("1.2.4.5"))
        XCTAssertFalse(version == Version("1.2"))
    }
    
    func testExpressionless() {
        let version: Version = "1.2.4"
        
        XCTAssertFalse(version < Version("1.2.2"))
        XCTAssertFalse(version < Version("1.1.4"))
        XCTAssertFalse(version < Version("1.2.4"))
        XCTAssertFalse(version < Version("0.2.4"))
        XCTAssertTrue(version < Version("1.2.4.5"))
        XCTAssertFalse(version < Version("1.2"))
    }
    
    func testExpressionMore() {
        let version: Version = "1.2.4"
        
        XCTAssertTrue(version > Version("1.2.2"))
        XCTAssertTrue(version > Version("1.1.4"))
        XCTAssertFalse(version > Version("1.2.4"))
        XCTAssertTrue(version > Version("0.2.4"))
        XCTAssertFalse(version > Version("1.2.4.5"))
        XCTAssertTrue(version > Version("1.2"))
    }

    static var allTests = [
        ("testExpressionEquality", testExpressionEquality),
        ("testExpressionless", testExpressionless),
        ("testExpressionMore", testExpressionMore),
    ]
}
