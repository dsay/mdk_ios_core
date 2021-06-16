import Foundation

public enum ForceUpdateError: LocalizedError {
    
    case parsingError
    case requiredUpdate(String)
    case recommendedUpdate(String)
}

public protocol ForceUpdateConfig {
    
    var isRequired: Bool { get }
    var version: String { get }
    var storeURL: String { get }
}

public struct ForceUpdate {
    
    public init() {
        
    }
    
    public func fetch(config: ForceUpdateConfig) -> Result<Void, ForceUpdateError> {
        
        if let boundleVersionS = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            let appVersion = Version(boundleVersionS)
            let currentVersion = Version(config.version)
            
            if appVersion < currentVersion {
                if config.isRequired {
                    return .failure(.requiredUpdate(config.storeURL))
                } else {
                    return .failure(.recommendedUpdate(config.storeURL))
                }
            } else {
                return .success(())
            }
        } else {
            return .failure(.parsingError)
        }
    }
}
