
import UIKit
import FTDomainData

public protocol RegistrationState {
    var nextAction: (RegistrationState) -> () { get set }
    func viewsToPresent() -> [UIView]
    func apply(user: inout FTUser)
}
