import Foundation

extension Array {
    func safeGet(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public struct Version: Codable {
    
    private(set) var components: [Int] = []
    
    public init(_ value: String) {
        components = value
            .split(separator: ".", omittingEmptySubsequences: false)
            .compactMap({ Int($0) })
    }
    
    public init(_ version: Version) {
        components = version.components
    }
    
    func compare(_ another: Version) -> ComparisonResult {
        let maxCount = max(components.count, another.components.count)
        
        var result = ComparisonResult.orderedSame
        for index in 0..<maxCount {
            let left = NSNumber(value: components.safeGet(at: index) ?? 0)
            let right = NSNumber(value: another.components.safeGet(at: index) ?? 0)
            
            result = left.compare(right)
            if result != .orderedSame {
                return result
            }
        }
        
       return result
    }
}

extension Version: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Version {
    
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    public static func > (lhs: Version, rhs: Version) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }
}
