
import FTDomainData

public protocol RegistrationModel {
    var userRegister: FTUserRegister { get set }
    var stepCount: Int { get }
    var currentState: Int { get }
    func goNext() -> (any RegistrationState)?
    func getPreviousState() -> (any RegistrationState)?
    func popPreviousState() -> (any RegistrationState)?
    func register(user: FTUserRegister, completion: @escaping (Result<Void, Error>) -> ())
}

public final class BaseRegistrationModel: RegistrationModel {
    
    public var userRegister = FTUserRegister()
    public var currentState = -1
    let userInterface: any FTUserInterface
    
    private var states: [any RegistrationState]
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
        states[safe: currentState]?.apply(userRegister: &userRegister)
        let state = getCorrectNextState()
        return state
    }
    
    public func getPreviousState() -> (any RegistrationState)? {
        return states[safe: currentState]
    }
    
    public func popPreviousState() -> (any RegistrationState)? {
        currentState -= 1
        return states.popLast()
    }
    
    private func getCorrectNextState() -> (any RegistrationState)? {
        if currentState == 2 { //после регистрации переходить к доп инфе коуча или нет
            switch userRegister.role {
            case .client, .admin: return nil
            case .coach: break
            }
        }
        currentState += 1
        return states[safe: currentState]
    }
    
    public func register(user: FTUserRegister, completion: @escaping (Result<Void, Error>) -> Void) {
        let state = states[safe: currentState]
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
                        ErrorPresenter.present(error)
                        completion(.failure(error))
                    }
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
                ErrorPresenter.present(error)
            }
        })
    }
    
}
