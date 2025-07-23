
import Foundation

public extension String {
    var doubleValue: Double? {
        let string = self.replacingOccurrences(of: ",", with: ".")
        return Double(string)
    }
}
