
import UIKit
import XCTest
@testable import FitnessTogether

internal class MockScreenStateDelegate: ScreenStateDelegate {
    
    var goNextCalled = false
    var lastAfterView: UIView?
    var lastViewInserted: UIView?
    var lastViewRemoved: UIView?
    
    func screenStateGoNext(_ state: ScreenState) {
        goNextCalled = true
    }
    
    func screenState(_ state: ScreenState, needInertView view: UIView, after afterView: UIView) {
        lastAfterView = afterView
        lastViewInserted = view
    }
    
    func screenState(_ state: ScreenState, needReplaceView view: UIView, with otherView: UIView) {}
    
    func screenState(_ state: ScreenState, needRemoveView view: UIView) {
        lastViewRemoved = view
    }
}
