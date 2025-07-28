
import UIKit
import XCTest
@testable import FitnessTogether

internal class MockRegistrationDelegate: ScreenStateDelegate {
    
    var goNextCalled = false
    var lastAfterView: UIView?
    var lastViewInserted: UIView?
    var lastViewRemoved: UIView?
    
    func screenStateGoNext(_ state: RegistrationState) {
        goNextCalled = true
    }
    
    func screenState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView) {
        lastAfterView = afterView
        lastViewInserted = view
    }
    
    func screenState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView) {}
    
    func screenState(_ state: RegistrationState, needRemoveView view: UIView) {
        lastViewRemoved = view
    }
}
