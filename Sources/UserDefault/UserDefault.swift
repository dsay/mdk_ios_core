import Foundation

@propertyWrapper
public struct UserDefaultsStored<Value> {
    
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    public init(wrappedValue defaultValue: Value, key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    public var wrappedValue: Value {
        get {
             storage.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
    
    public func clear() {
        storage.setValue(nil, forKey: key)
    }
}

public extension UserDefaultsStored where Value: ExpressibleByNilLiteral {
    
    init(key: String, storage: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}

private protocol AnyOptional {
    
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    
    var isNil: Bool {
        self == nil
    }
}
