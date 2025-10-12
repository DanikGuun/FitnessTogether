
import FTDomainData
import UIKit

public extension FTWorkoutKind {
    
    var color: UIColor {
        switch self {
        case .none: .systemTeal
        case .force: .systemRed
        case .cardio: .systemBlue
        case .functional: .systemGreen
        case .split: .systemYellow
        case .fullbody: .systemCyan
        }
    }
    
}
