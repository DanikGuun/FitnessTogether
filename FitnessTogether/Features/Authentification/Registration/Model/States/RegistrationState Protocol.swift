
import UIKit
import FTDomainData

public protocol RegistrationState: ScreenState, AnyObject {
    func apply(userRegister: inout FTUserRegister)
    func setNextButtonBusy(_ available: Bool)
}

