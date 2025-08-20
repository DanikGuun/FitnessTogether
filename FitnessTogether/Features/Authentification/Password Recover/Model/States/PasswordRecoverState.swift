
import UIKit
import FTDomainData

public protocol PasswordRecoverState: ScreenState {
    func apply(to resetData: inout FTResetPassword)
    func setNextButtonBusy(_ available: Bool)
}
