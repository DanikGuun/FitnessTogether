
import FTDomainData

public protocol RegistrationModel {
    var userRegister: FTUserRegister { get set }
    var stepCount: Int { get }
    func goNext() -> (any RegistrationState)?
    func register(user: FTUserRegister)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public var userRegister = FTUserRegister()
    public let stepCount = 3
    
    private var states: [any RegistrationState]
    private var currentState = -1
    
    public init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        self.states = [
            RegistrationPersonalDataState(validator: validator),
            RegistrationCredintalsState(validator: validator, emailConfirmer: emailConfirmer),
            RegistrationRoleState(validator: validator),
            RegistrationCoachInfoState(validator: validator)
        ]
    }
    
    public func goNext() -> (any RegistrationState)? {
        currentState += 1
        let state = getCorrectNextState()
        return state
    }
    
    private func getCorrectNextState() -> (any RegistrationState)? {
        guard currentState < states.count else { return nil }
        if currentState == 3 { //после регистрации переходить к доп инфе коуча или нет
            switch userRegister.role {
            case .client, .admin: return nil
            case .coach: break
            }
        }
        return states[currentState]
    }
    
    public func register(user: FTUserRegister) {
        
    }
    
}
