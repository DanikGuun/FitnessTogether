
import FTDomainData

public protocol RegistrationModel {
    func getStates() -> [RegistrationState]
    func register(user: FTUser)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public func getStates() -> [any RegistrationState] {
        let validator = BaseValidator()
        return [
            RegistrationCredintalsState(validator: validator),
            RegistrationPersonalDataState(validator: validator)
        ]
    }
    
    public func register(user: FTUser) {
        
    }
    
    
}
