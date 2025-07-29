
import UIKit
import FTDomainData

public protocol PasswordRecoverState: ScreenState {
    func apply()
    func setNextButtonBusy(_ available: Bool)
}
