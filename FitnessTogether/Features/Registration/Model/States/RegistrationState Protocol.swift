
import UIKit
import FTDomainData

public protocol RegistrationState {
    func viewsToPresent() -> [UIView]
    func apply(user: inout FTUser)
}
