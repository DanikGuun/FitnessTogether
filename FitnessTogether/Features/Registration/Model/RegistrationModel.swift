
import FTDomainData

public protocol RegistrationModel {
    var userRegister: FTUserRegister { get set }
    var stepCount: Int { get }
    func goNext() -> (any RegistrationState)?
    func register(user: FTUserRegister)
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public var userRegister = FTUserRegister()
    let userInterface: any FTUserInterface
    
    private var states: [any RegistrationState]
    private var currentState = -1
    public let stepCount = 3
    
    public init(userInterface: any FTUserInterface, validator: any Validator, emailConfirmer: any EmailConfirmer) {
        self.userInterface = userInterface
        self.states = [
            RegistrationPersonalDataState(validator: validator),
            RegistrationCredintalsState(validator: validator, emailConfirmer: emailConfirmer),
            RegistrationRoleState(),
            RegistrationCoachInfoState(validator: validator),
        ]
    }
    
    public func goNext() -> (any RegistrationState)? {
        currentState += 1
        let state = getCorrectNextState()
        if state == nil { register(user: userRegister) }
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
        let state = states[currentState]
        state.setNextButtonBusy(false)
        userInterface.register(data: user, completion: { [weak self] result in
            switch result {
            case .success(_):
                let loginData = FTUserLogin(email: user.email, password: user.password)
                self?.userInterface.login(data: loginData, completion: { _ in
                    state.setNextButtonBusy(true)
                })
            case .failure(let error):
                print(error.description)
            }
        })
    }
    
}
