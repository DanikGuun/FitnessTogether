
import FTDomainData

public protocol RegistrationModel {
    func getStates() -> [RegistrationState]
    func register(user: FTUser)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public func getStates() -> [any RegistrationState] {
        return [
            RegistrationPersonalDataState(),
            RegistrationPersonalDataState(),
            RegistrationPersonalDataState(),
            RegistrationPersonalDataState(),
            RegistrationPersonalDataState(),
            RegistrationPersonalDataState()
        ]
    }
    
    public func register(user: FTUser) {
        
    }
    
    
}
