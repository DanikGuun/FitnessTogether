
public protocol PasswordRecoverModel {
    var stepCount: Int { get }
    //тут будет структура сброса
    func goNext() -> (any PasswordRecoverState)?
    func resetPassword()
}

public final class BasePasswordRecoverModel: PasswordRecoverModel {
    public let stepCount: Int = 3
    private var currentStep = -1
    
    private var states: [(any PasswordRecoverState)] = []
    
    init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        self.states = [
            PasswordRecoverCodeState(emailConfirmer: emailConfirmer),
            PasswordRecoverEmailState(validator: validator, emailConfirmer: emailConfirmer),
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
        currentStep += 1
        guard currentStep >= 0, currentStep < states.count else { return nil }
        return states[currentStep]
    }
    
    public func resetPassword() {
        
    }
    
    
}
