
import FTDomainData

public protocol RegistrationModel {
    var userRegister: FTUserRegister { get set }
    var stepCount: Int { get }
    func goNext() -> (any RegistrationState)?
    func register(user: FTUser)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public var userRegister = FTUserRegister()
    public let stepCount = 3
    
    let validator: any Validator
    let emailConfirmer: (any EmailConfirmer)!
    
    private var states: [any RegistrationState]
    private var currentState = -1
    
    public init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        self.validator = validator
        self.emailConfirmer = emailConfirmer
        self.states = [
            RegistrationPersonalDataState(validator: validator),
            RegistrationCredintalsState(validator: validator, emailConfirmer: emailConfirmer),
            RegistrationRoleState(validator: validator)
        ]
    }
    
    public func goNext() -> (any RegistrationState)? {
        currentState += 1
        if currentState < states.count {
            return states[currentState]
        }
        else if userRegister.role == .coach {
            return RegistrationCoachInfoState(validator: validator)
        }
        return nil
    }
    
    public func register(user: FTUser) {
        
    }
    
    
}
