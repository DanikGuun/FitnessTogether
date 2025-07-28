
import UIKit

public protocol ScreenState: AnyObject {
    var delegate: ScreenStateDelegate? { get set }
    func viewsToPresent() -> [UIView]
}

public protocol ScreenStateDelegate {
    func screenStateGoNext(_ state: RegistrationState)
    func screenState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView)
    func screenState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView)
    func screenState(_ state: RegistrationState, needRemoveView view: UIView)
}

public extension ScreenStateDelegate {
    func screenStateGoNext(_ state: RegistrationState) {}
    func screenState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView) {}
    func screenState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView) {}
    func screenState(_ state: RegistrationState, needRemoveView view: UIView) {}
}
