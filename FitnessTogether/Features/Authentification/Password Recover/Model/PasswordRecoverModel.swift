
import Foundation

public protocol PasswordRecoverModel {
    var stepCount: Int { get }
    var currentStep: Int { get }
    //тут будет структура сброса
    func goNext() -> (any PasswordRecoverState)?
    func getPreviousState() -> (any PasswordRecoverState)?
    func resetPassword(completion: ((Result<Void, Error>) -> ())?)
}

public final class BasePasswordRecoverModel: PasswordRecoverModel {
    public let stepCount: Int = 3
    public var currentStep = -1
    
    private var states: [(any PasswordRecoverState)] = []
    
    init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        let recoverManager = PasswordRecoverNetwork()
        self.states = [
            PasswordRecoverEmailState(validator: validator, recoverManager: recoverManager),
            PasswordRecoverCodeState(recoverManager: recoverManager),
            PasswordRecoverNewPasswordState(validator: validator),
        ]
    }
    
    public func goNext() -> (any PasswordRecoverState)? {
        states[safe: currentStep]?.apply()
        guard let state = getNextState() else { return nil }
        return state
    }
    
    public func getPreviousState() -> (any PasswordRecoverState)? {
        currentStep -= 1
        return states[safe: currentStep]
    }
    
    private func getNextState() -> (any PasswordRecoverState)? {
        currentStep += 1
        return states[safe: currentStep]
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
