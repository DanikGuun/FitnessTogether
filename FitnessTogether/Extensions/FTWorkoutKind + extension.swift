
import FTDomainData
import UIKit

public extension FTWorkoutKind {
    
    var color: UIColor {
        switch self {
        case .none: .black
        case .force: .systemRed
        case .cardio: .systemBlue
        case .functional: .systemGreen
        }
    }
    
}
