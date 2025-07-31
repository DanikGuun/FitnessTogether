
import Foundation

public extension Comparable {
    
    func clamp(min minimum: Self, max maximum: Self) -> Self {
        return max(min(self, maximum), minimum)
    }
    
}
