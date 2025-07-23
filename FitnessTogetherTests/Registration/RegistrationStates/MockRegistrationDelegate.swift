
import UIKit
import XCTest
@testable import FitnessTogether

internal class MockRegistrationDelegate: RegistrationStateDelegate {
    
    var goNextCalled = false
    var lastAfterView: UIView?
    var lastViewInserted: UIView?
    var lastViewRemoved: UIView?
    
    func registrationStateGoNext(_ state: RegistrationState) {
        goNextCalled = true
    }
    
    func registrationState(_ state: RegistrationState, needInertView view: UIView, after afterView: UIView) {
        lastAfterView = afterView
        lastViewInserted = view
    }
    
    func registrationState(_ state: RegistrationState, needReplaceView view: UIView, with otherView: UIView) {}
    
    func registrationState(_ state: RegistrationState, needRemoveView view: UIView) {
        lastViewRemoved = view
    }
}
