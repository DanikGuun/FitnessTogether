
import FTDomainData

public protocol RegistrationModel {
    var userRegister: FTUserRegister { get set }
    var stepCount: Int { get }
    func goNext() -> (any RegistrationState)?
    func register(user: FTUserRegister, completion: @escaping (Result<Void, Error>) -> ())
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
        applyStateData()
        let state = getCorrectNextState()
        return state
    }
    
    private func applyStateData() {
        guard currentState >= 0, currentState <= states.count else { return }
        let state = states[currentState]
        state.apply(userRegister: &userRegister)
    }
    
    private func getCorrectNextState() -> (any RegistrationState)? {
        guard currentState < states.count else { return nil }
        if currentState == 2 { //после регистрации переходить к доп инфе коуча или нет
            switch userRegister.role {
            case .client, .admin: return nil
            case .coach: break
            }
        }
        currentState += 1
        return states[currentState]
    }
    
    public func register(user: FTUserRegister, completion: @escaping (Result<Void, Error>) -> Void) {
        let state = getCurrentState()
        state?.setNextButtonBusy(true)
        userInterface.register(data: user, completion: { [weak self] result in
            switch result {
            case .success(_):
                
                let loginData = FTUserLogin(email: user.email, password: user.password)
                self?.userInterface.login(data: loginData, completion: { _ in
                    state?.setNextButtonBusy(false)
                    
                    switch result {
                    case .success(_):
                        completion(.success(Void()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                
            case .failure(let error):
                print(error.description)
                completion(.failure(error))
            }
        })
    }
    
    private func getCurrentState() -> (any RegistrationState)? {
        if currentState >= 0 && currentState < states.count {
            return states[currentState]
        }
        return nil
    }
    
}
