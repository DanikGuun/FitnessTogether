
import XCTest
@testable import FitnessTogether
import FTDomainData


class MockFTManager: FTManager {
    
    var user: any FitnessTogether.FTUserInterface { _user }
    var workout: any FitnessTogether.FTWorkoutInterface { _workout }
    var exercise: any FitnessTogether.FTExerciseInterface { _exercise }
    var set: any FitnessTogether.FTSetInterface { _set }
    
    
    var _user = MockUserInterface()
    var _workout = MockWorkoutInterface()
    var _exercise = MockExerciseInterface()
    var _set = MockSetInterface()
    
}

class MockUserInterface: FTUserInterface {
    var token: String? = nil
    var hasPreviousLogin: Bool = false
    
    var lastRegisterData: FTDomainData.FTUserRegister?
    var lastLoginData: FTDomainData.FTUserLogin?
    var user: FTUser? = FTUser()
    
    func register(data: FTDomainData.FTUserRegister, completion: FTDomainData.FTCompletion<Data>) {
        lastRegisterData = data
        completion?(.success(Data()))
    }
    
    func login(data: FTDomainData.FTUserLogin, completion: FTDomainData.FTCompletion<Data>) {
        lastLoginData = data
        completion?(.success(Data()))
    }
    
    func loginWithPreviousCredentials(completion: FTDomainData.FTCompletion<Data>) {}
    
    func logout(completion: FTDomainData.FTCompletion<Void>) {}
    
    func current(completion: FTDomainData.FTCompletion<FTDomainData.FTUser>) {
        guard let user else { completion?(.failure(.unknown)); return }
        completion?(.success(user))
    }
    
    func addClientToCoach(clientId: String, completion: FTDomainData.FTCompletion<Void>) {}
    
    func getClients(completion: FTDomainData.FTCompletion<[FTDomainData.FTUser]>) {}
    
}

class MockWorkoutInterface: FTWorkoutInterface {
    func create(data: FTDomainData.FTWorkoutCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTWorkout>) {}
    
    func get(workoutId: String, completion: FTDomainData.FTCompletion<FTDomainData.FTWorkout>) {}
    
    func getAll(completion: FTDomainData.FTCompletion<[FTDomainData.FTWorkout]>) {}
    
    func edit(workoutId: String, newData data: FTDomainData.FTWorkoutCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTWorkout>) {}
    
    func delete(workoutId: String, completion: FTDomainData.FTCompletion<Void>) {}
    
    
}

class MockExerciseInterface: FTExerciseInterface {
    func create(data: FTDomainData.FTExerciseCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTExercise>) {}
    
    func get(exerciseId: String, completion: FTDomainData.FTCompletion<FTDomainData.FTExercise>) {}
    
    func get(workoutId: String, completion: FTDomainData.FTCompletion<[FTDomainData.FTExercise]>) {}
    
    func update(exerciseId: String, data: FTDomainData.FTExerciseCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTExercise>) {}
    
    func delete(exerciseId: String, completion: FTDomainData.FTCompletion<Void>) {}
    
    
}

class MockSetInterface: FTSetInterface {
    func create(data: FTDomainData.FTSetCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTSet>) {}
    
    func get(setId: String, completion: FTDomainData.FTCompletion<FTDomainData.FTSet>) {}
    
    func get(exerciseId: String, completion: FTDomainData.FTCompletion<[FTDomainData.FTSet]>) {}
    
    func edit(setId: String, newData data: FTDomainData.FTSetCreate, completion: FTDomainData.FTCompletion<FTDomainData.FTSet>) {}
    
    func delete(setId: String, completion: FTDomainData.FTCompletion<Void>) {}
    
    
}
