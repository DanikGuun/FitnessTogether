
import FTDomainData
import Foundation

public protocol PasswordRecoverModel {
    var stepCount: Int { get }
    var currentStep: Int { get }
    var resetPasswordData: FTResetPassword { get set }
    func goNext() -> (any PasswordRecoverState)?
    func getPreviousState() -> (any PasswordRecoverState)?
    func resetPassword(completion: ((Result<Void, Error>) -> ())?)
}

public final class BasePasswordRecoverModel: PasswordRecoverModel {
    public let stepCount: Int = 3
    public var currentStep = -1
    public var resetPasswordData = FTResetPassword()
    
    let ftManager: FTManager
    private var states: [(any PasswordRecoverState)] = []
    
    init(ftManager: any FTManager, validator: any Validator) {
        self.ftManager = ftManager
        let recoverManager = PasswordRecoverNetwork(ftManager: ftManager)
        self.states = [
            PasswordRecoverEmailState(validator: validator, recoverManager: recoverManager),
            PasswordRecoverCodeState(recoverManager: recoverManager),
            PasswordRecoverNewPasswordState(validator: validator),
        ]
    }
    
    public func goNext() -> (any PasswordRecoverState)? {
        states[safe: currentStep]?.apply(to: &resetPasswordData)
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

        ftManager.email.resetPassword(data: resetPasswordData, completion: { result in
            switch result {
                
            case .success(_):
                state?.setNextButtonBusy(false)
                completion?(.success(()))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        })
    }
    
    private func getCurrentState() -> (any PasswordRecoverState)? {
        guard currentStep >= 0, currentStep < states.count else { return nil }
        return states[currentStep]
    }
    
}
