
import UIKit
import FTDomainData

public protocol RegistrationState {
    var delegate: RegistrationStateDelegate? { get set }
    func viewsToPresent() -> [UIView]
    func apply(userRegister: inout FTUserRegister)
}

public protocol RegistrationStateDelegate {
    func registrationStateGoNext(_ state: RegistrationState)
    func registrationState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView)
    func registrationState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView)
    func registrationState(_ state: RegistrationState, needRemoveView view: UIView)
}

public extension RegistrationStateDelegate {
    func registrationStateGoNext(_ state: RegistrationState) {}
    func registrationState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView) {}
    func registrationState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView) {}
    func registrationState(_ state: RegistrationState, needRemoveView view: UIView) {}
}
