import Foundation

open class ServiceLocator {

    static public let shared = ServiceLocator()

    private var registry: [ServiceKey: Any] = [:]

    public func register<T>(service: @escaping (ServiceLocator) -> T, name: String? = nil) {
        let key = ServiceKey(serviceType: T.self, name: name)
        
        registry[key] = service
    }

    public func register<T>(service: T, name: String? = nil) {
        let key = ServiceKey(serviceType: T.self, name: name)
        
        registry[key] = service
    }

    public func tryGetService<T>(name: String? = nil) -> T? {
        let key = ServiceKey(serviceType: T.self, name: name)

        switch registry[key] {
        case let service as T:
            return service
            
        case let service as (ServiceLocator) -> T:
            return service(self)
            
        default:
            return nil
        }
    }
    
    public func getService<T>(name: String? = nil) -> T {
        if let service: T = tryGetService(name: name) {
            return service
        } else {
            fatalError("Service: \(T.self) was not registerd!!!")
        }
    }

    public func unregister<T>(service: T, name: String? = nil) {
        let key = ServiceKey(serviceType: T.self, name: name)
        
        registry.removeValue(forKey: key)
    }
}

private struct ServiceKey {

    let serviceType: Any.Type
    let name: String?
}

extension ServiceKey: Hashable {

    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.serviceType == rhs.serviceType &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        name?.hash(into: &hasher)
    }
}

@propertyWrapper
public struct Injection<T> {

    public init() {
    
    }
    
    public var wrappedValue: T {
        get {
            return ServiceLocator.shared.getService()
        }
        set {
            ServiceLocator.shared.register(service: newValue)
        }
    }
}
