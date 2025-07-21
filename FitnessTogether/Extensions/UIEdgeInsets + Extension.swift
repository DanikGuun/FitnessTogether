
import UIKit

public extension UIEdgeInsets {
    var nsInsets: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
