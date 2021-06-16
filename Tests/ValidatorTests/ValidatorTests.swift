import XCTest
@testable import Validator

enum TestError: Error {
    case empty
    case notEqual
    case password
    case email
    case pin
}

final class ValidatorTests: XCTestCase {
    
    func right<T, E: Error>(result: Result<T, E>) {
        switch result {
        case .success:
            XCTPass()
        case .failure:
            XCTFail()
        }
    }
    
    func wrong<T, E: Error>(result: Result<T, E>) {
        switch result {
        case .success:
            XCTFail()
        case .failure:
            XCTPass()
        }
    }
    
    func right<T, E: Error>(result: Result<T?, E>) {
        switch result {
        case .success:
            XCTPass()
        case .failure:
            XCTFail()
        }
    }
    
    func wrong<T, E: Error>(result: Result<T?, E>) {
        switch result {
        case .success:
            XCTFail()
        case .failure:
            XCTPass()
        }
    }
    
    func testValidateLength(){
        let text = "test"
        let empty = ""
        let nilText: String? = nil

        let rule = Validator().min(1, TestError.empty)
        
        self.right(result: rule.optional(text))
        self.wrong(result: rule.optional(empty))
        self.right(result: rule.optional(nilText))
                
        self.right(result: rule.required(text))
        self.wrong(result: rule.required(empty))
        self.wrong(result: rule.required(nilText))
    }
    
    func testValidateRequired(){
        let text = "test"
        let empty = ""
        let nilText: String? = nil

        let rule = Validator().required(TestError.empty)
        
        self.right(result: rule.optional(text))
        self.right(result: rule.optional(empty))
        self.wrong(result: rule.optional(nilText))
    }
    
    func testValidateMax(){
        let text = "test"
        let empty = ""
        let nilText: String? = nil

        let rule = Validator().max(3, TestError.empty)
        
        self.wrong(result: rule.optional(text))
        self.right(result: rule.optional(empty))
        self.right(result: rule.optional(nilText))
                
        self.wrong(result: rule.required(text))
        self.right(result: rule.required(empty))
        self.wrong(result: rule.required(nilText))
    }
    
    func testValidateIsEqual() {
        let text = "test"
        let text1 = "test"
        let text2 = ""

        let rule = Validator().isEqual(text, TestError.notEqual)
        self.right(result: rule.required(text1))
        self.wrong(result: rule.required(text2))
        self.wrong(result: rule.required(nil))
    }
    
    func testValidateEmail() {
        self.right(result: validate(email: "test@test.com"))
        self.wrong(result: validate(email: ""))
        self.wrong(result: validate(email: nil))
        self.wrong(result: validate(email: "test@"))
        self.wrong(result: validate(email: "test@test"))
        self.wrong(result: validate(email: "test@test."))
    }
    
    func testValidatePassword() {
        self.right(result: validate(password: "Pass1234"))
        self.wrong(result: validate(password: ""))
        self.wrong(result: validate(password: nil))
        self.wrong(result: validate(password: "Passord"))
        self.wrong(result: validate(password: "password1234"))
        self.wrong(result: validate(password: "1234"))
    }
    
    func testValidateConfirmPassword() {
        self.right(result: validate(password: "Pass1234", confirm: "Pass1234"))
        self.wrong(result: validate(password: "Pass1234", confirm: ""))
        self.wrong(result: validate(password: "Pass1234", confirm: nil))
        self.wrong(result: validate(password: "Pass1234", confirm: "Padd"))
    }
    
    func testValidatePin() {
        self.right(result: validate(pin: "12345"))
        self.wrong(result: validate(pin: "1234"))
        self.wrong(result: validate(pin: "123456"))
        self.wrong(result: validate(pin: nil))
    }
    
    func testValidateName() {
        self.right(result: validate(name: "Test"))
        self.wrong(result: validate(name: ""))
        self.wrong(result: validate(name: nil))
    }
    
    func validate(email: String?) -> Result<String, TestError> {
        Validator()
            .required(.empty)
            .email(.email)
            .required(email)
    }
    
    func validate(password: String?) -> Result<String, TestError> {
        Validator()
            .required(.empty)
            .password(.password)
            .required(password)
    }
    
    func validate(password: String?, confirm: String?) -> Result<String, TestError> {
        Validator()
            .required(.empty)
            .isEqual(password, .notEqual)
            .required(confirm)
    }
    
    func validate(pin: String?) -> Result<String, TestError> {
        Validator()
            .required(.empty)
            .min(5, .pin)
            .max(5, .pin)
            .required(pin)
    }
    
    func validate(name: String?) -> Result<String, TestError> {
        Validator()
            .min(1, .empty)
            .required(name)
    }
    
    static var allTests = [
        ("testValidateLength", testValidateLength),
        ("testValidateName", testValidateName),
        ("testValidatePin", testValidatePin),
        ("testValidateConfirmPassword", testValidateConfirmPassword),
        ("testValidatePassword", testValidatePassword),
        ("testValidateEmail", testValidateEmail),
        ("testValidateIsEqual", testValidateIsEqual),
        ("testValidateMax", testValidateMax),
        ("testValidateRequired", testValidateRequired),
    ]
}

extension XCTestCase {
    
    func XCTPass() {
        XCTAssertTrue(true)
    }
}
