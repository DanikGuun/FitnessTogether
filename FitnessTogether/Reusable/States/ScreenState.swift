
import UIKit

public protocol ScreenState: AnyObject {
    var delegate: (any ScreenStateDelegate)? { get set }
    func viewsToPresent() -> [UIView]
}

public protocol ScreenStateDelegate {
    func screenStateGoNext(_ state: ScreenState)
    func screenState(_ state: ScreenState, needInertView view: UIView, after afterView: UIView)
    func screenState(_ state: ScreenState, needReplaceView view: UIView, with otherView: UIView)
    func screenState(_ state: ScreenState, needRemoveView view: UIView)
}

public extension ScreenStateDelegate {
    func screenStateGoNext(_ state: ScreenState) {}
    func screenState(_ state: ScreenState, needInertView view: UIView, after afterView: UIView) {}
    func screenState(_ state: ScreenState, needReplaceView view: UIView, with otherView: UIView) {}
    func screenState(_ state: ScreenState, needRemoveView view: UIView) {}
}
