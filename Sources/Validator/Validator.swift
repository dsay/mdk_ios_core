import Foundation

public struct Regex {
    
    static let EmailRegex: String = "[\\w._%+-|]+@[\\w0-9.-]+\\.[A-Za-z]{2,}"
    static let AlphaRegex: String = "(?:[a-zA-Z0-9+/]){0,2}"
    static let Base64Regex: String = "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?"
    static let CreditCardRegex: String = "(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})"
    static let Password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
    static let HexColorRegex: String = "#?([0-9A-F]{3}|[0-9A-F]{6})"
    static let HexadecimalRegex: String = "[0-9A-F]+"
    static let ASCIIRegex: String = "[\\x00-\\x7F]+"
    static let NumericRegex: String = "[-+]?[0-9]+"
    static let FloatRegex: String = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?"
    static let IPRegex: [String: String] = [
        "4": "(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})",
        "6": "[0-9A-Fa-f]{1,4}"
    ]
    static let ISBNRegex: [String: String] = [
        "10": "(?:[0-9]{9}X|[0-9]{10})",
        "13": "(?:[0-9]{13})"
    ]
    static let AlphanumericRegex: String = "[\\d[A-Za-z]]+"
}

open class Validator<InputType, ValidationError: Error> {
    
    typealias ValidationRule = (InputType?, Bool) -> Result<Void, ValidationError>

    private var rules: [ValidationRule] = []

    public init() {
        
    }
    
    public func optional(_ value: InputType?) -> Result<InputType?, ValidationError> {
        if case .failure(let error) = rules.map({ $0(value, true) }).first(where: { $0.isFailure }) {
            return .failure(error)
        } else {
            return .success(value)
        }
    }
    
    public func required(_ value: InputType?) -> Result<InputType, ValidationError> {
        if case .failure(let error) = rules.map({ $0(value, false) }).first(where: { $0.isFailure }) {
            return .failure(error)
        } else {
            guard let value = value else {
                fatalError("Use .required rule for this method !!!!")
            }
            return .success(value)
        }
    }
}

public extension Validator where InputType == String {

    func required(_ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            (value != nil).map(error)
        }
        return self
    }
    
    func min(_ length: Int, _ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            guard let value = value else {
                return nilResponse.map(error)
            }
            return (value.count >= length).map(error)
        }
        return self
    }
    
    func max(_ length: Int, _ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            guard let value = value else {
                return nilResponse.map(error)
            }
            return (value.count <= length).map(error)
        }
        return self
    }
    
    func isEqual(_ string: String?, _ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            guard let value = value else {
                return nilResponse.map(error)
            }
            return (value == string).map(error)
        }
        return self
    }
    
    func email(_ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            self.regex(value: value, Regex.EmailRegex, error, nilResponse)
        }
        return self
    }
    
    func password(_ error: ValidationError) -> Validator {
        self.rules.append { value, nilResponse in
            self.regex(value: value, Regex.Password, error, nilResponse)
        }
        return self
    }
    
    private func regex(value: String?, _ regex: String, _ error: ValidationError, _ nilResponse: Bool = false) -> Result<Void, ValidationError> {
        guard let value = value else {
            return nilResponse.map(error)
        }
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: value).map(error)
    }
}

public extension Result {
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var isFailure: Bool {
        switch self {
        case .success:
            return false
        default:
            return true
        }
    }
    
    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

public extension Bool {
    
     func map<E: Error>(_ error: E) -> Result<Void, E> {
        if self == true {
            return .success(())
        } else {
            return .failure(error)
        }
    }
}
