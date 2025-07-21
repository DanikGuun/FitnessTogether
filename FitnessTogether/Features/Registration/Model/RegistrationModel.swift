
import FTDomainData

public protocol RegistrationModel {
    func getStates() -> [RegistrationState]
    func register(user: FTUser)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public func getStates() -> [any RegistrationState] {
        let validator = BaseValidator()
        return [
            RegistrationPersonalDataState(validator: validator),
            RegistrationCredintalsState(validator: validator),
            RegistrationRoleState(validator: validator)
        ]
    }
    
    public func register(user: FTUser) {
        
    }
    
    
}
