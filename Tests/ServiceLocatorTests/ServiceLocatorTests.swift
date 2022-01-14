import XCTest
@testable import ServiceLocator

protocol TestProtocol {
    
}

class TestService: NSObject, TestProtocol {
    
}

final class ServiceLocatorTests: XCTestCase {
    
    var serviceLocator: ServiceLocator!
    
    override func setUp() {
        super.setUp()
        self.serviceLocator = ServiceLocator()
    }

    func testGetNotRegistredService() {
        let test: TestService? = serviceLocator.tryResolve()
        XCTAssertEqual(test, nil)
    }
    
    func testGetService() {
        let test = TestService()
        serviceLocator.register(service: test)
        
        let test1: TestService? = serviceLocator.tryResolve()
        XCTAssertEqual(test, test1)
    }
    
    func testGetProtocol() {
        let test: TestProtocol = TestService()
        serviceLocator.register(service: test)
        
        let test1: TestProtocol? = serviceLocator.tryResolve()
        XCTAssertNotNil(test1)
    }
    
    func testGetDynamicService() {
        serviceLocator.register { _ in
            TestService()
        }
        
        let test: TestService? = serviceLocator.tryResolve()
        XCTAssertNotNil(test)
    }
    
    func testGetServiceWithName() {
        let some1 = TestService()
        let some2 = TestService()

        serviceLocator.register(service: some1, name: "Some1")
        serviceLocator.register(service: some2, name: "Some2")

        let testNil: TestService? = serviceLocator.tryResolve()
        XCTAssertEqual(testNil, nil)
        
        let test1: TestService? = serviceLocator.tryResolve(name: "Some1")
        
        XCTAssertEqual(some1, test1)
        XCTAssertNotEqual(some2, test1)
    }
    
    func testUnregister() {
        let test = TestService()
        serviceLocator.register(service: test)
        
        let test1: TestService? = serviceLocator.tryResolve()
        XCTAssertNotEqual(test1, nil)

        serviceLocator.unregister(service: test)
        
        let test2: TestService? = serviceLocator.tryResolve()

        XCTAssertEqual(test2, nil)
    }

    static var allTests = [
        ("testGetNotRegistredService", testGetNotRegistredService),
        ("testGetService", testGetService),
        ("testGetDynamicService", testGetDynamicService),
        ("testGetServiceWithName", testGetServiceWithName),
        ("testGetProtocol", testGetProtocol),
        ("testUnregister", testUnregister),
    ]
}
