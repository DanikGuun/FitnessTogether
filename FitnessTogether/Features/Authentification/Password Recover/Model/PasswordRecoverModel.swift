
import Foundation

public protocol PasswordRecoverModel {
    var stepCount: Int { get }
    //тут будет структура сброса
    func goNext() -> (any PasswordRecoverState)?
    func resetPassword(completion: ((Result<Void, Error>) -> ())?)
}

public final class BasePasswordRecoverModel: PasswordRecoverModel {
    public let stepCount: Int = 3
    private var currentStep = -1
    
    private var states: [(any PasswordRecoverState)] = []
    
    init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        self.states = [
            PasswordRecoverNewPasswordState(validator: validator),
            PasswordRecoverEmailState(validator: validator, emailConfirmer: emailConfirmer),
            PasswordRecoverCodeState(emailConfirmer: emailConfirmer),
        ]
    }
    
    public func goNext() -> (any PasswordRecoverState)? {
        applyStateData()
        guard let state = getNextState() else { return nil }
        return state
    }
    
    private func applyStateData() {
        guard currentStep >= 0, currentStep < states.count else { return }
        states[currentStep].apply()
    }
    
    private func getNextState() -> (any PasswordRecoverState)? {
        guard currentStep + 1 >= 0, currentStep + 1 < states.count else { return nil }
        currentStep += 1
        return states[currentStep]
    }
    
    public func resetPassword(completion: ((Result<Void, Error>) -> ())?) {
        let state = getCurrentState()
        state?.setNextButtonBusy(true)
        DispatchQueue.global().async {
            sleep(3)
            DispatchQueue.main.sync {
                state?.setNextButtonBusy(false)
                completion?(.success(Void()))
            }
        }
    }
    
    private func getCurrentState() -> (any PasswordRecoverState)? {
        guard currentStep >= 0, currentStep < states.count else { return nil }
        return states[currentStep]
    }
    
}
