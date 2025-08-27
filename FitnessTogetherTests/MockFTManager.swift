
import XCTest
@testable import FitnessTogether
import FTDomainData


class MockFTManager: FTManager {
    
    var email: any FitnessTogether.FTEmailInterface { _email }
    var user: any FitnessTogether.FTUserInterface { _user }
    var workout: any FitnessTogether.FTWorkoutInterface { _workout }
    var exercise: any FitnessTogether.FTExerciseInterface { _exercise }
    var set: any FitnessTogether.FTSetInterface { _set }
    
    var _email = MockEmailInterface()
    var _user = MockUserInterface()
    var _workout = MockWorkoutInterface()
    var _exercise = MockExerciseInterface()
    var _set = MockSetInterface()
    
}

class MockEmailInterface: FTEmailInterface {
    
    func forgotPassword(data: FTForgotPasswordEmail, completion: FTCompletion<FTResetCode>) {
        completion?(.success(FTResetCode(resetCode: "1")))
    }
    
    func resetPassword(data: FTResetPassword, completion: FTCompletion<Void>) {
        completion?(.success(()))
    }
    
}

class MockUserInterface: FTUserInterface {
    var token: String? = nil
    var hasPreviousLogin: Bool = false
    
    var lastRegisterData: FTUserRegister?
    var lastLoginData: FTUserLogin?
    var user: FTUser? = FTUser()
    
    func register(data: FTUserRegister, completion: FTCompletion<Data>) {
        lastRegisterData = data
        completion?(.success(Data()))
    }
    
    func login(data: FTUserLogin, completion: FTCompletion<Data>) {
        lastLoginData = data
        completion?(.success(Data()))
    }
    
    func loginWithPreviousCredentials(completion: FTCompletion<Data>) {}
    
    func logout(completion: FTCompletion<Void>) {}
    
    func current(completion: FTCompletion<FTUser>) {
        guard let user else { completion?(.failure(.unknown)); return }
        completion?(.success(user))
    }
    
    func addClientToCoach(clientId: String, completion: FTCompletion<Void>) {}
    
    public func getClients(completion: FTCompletion<[FTClientData]>) {
        let clients = user?.clients.map { $0.client.clientData }
        completion?(.success(clients ?? []))
    }
    
    public func getCoaches(completion: FTCompletion<[FTClientData]>) {
        let coaches = user?.coaches.map { $0.coach.clientData }
        completion?(.success(coaches ?? []))
    }
    
}

class MockWorkoutInterface: FTWorkoutInterface {
    var workouts: [FTWorkout] = []
    
    func create(data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        let workout = getWorkoutFromCreate(data)
        workouts.append(workout)
        completion?(.success(workout))
    }
    
    func get(workoutId: String, completion: FTCompletion<FTWorkout>) {
        let workout = workouts.first(where: { $0.id == workoutId })!
        completion?(.success(workout))
    }
    
    func getAll(completion: FTCompletion<[FTWorkout]>) {
        completion?(.success(workouts))
    }
    
    func edit(workoutId: String, newData data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        let index = workouts.firstIndex(of: workouts.first(where: { $0.id == workoutId })!)!
        let workout = getWorkoutFromCreate(data, id: workoutId)
        workouts[index] = workout
        
    }
    
    func delete(workoutId: String, completion: FTCompletion<Void>) {}
    
    private func getWorkoutFromCreate(_ workout: FTWorkoutCreate, id: String? = nil) -> FTWorkout {
        var newId = UUID().uuidString
        if let id { newId = id }
        let part = FTWorkoutParticipant(workoutId: newId, userId: workout.userId ?? "", role: .coach)
        let newWorkout = FTWorkout(id: newId, description: workout.description, startDate: workout.startDate.ftDate, participants: [part])
        return newWorkout
    }
    
}

class MockExerciseInterface: FTExerciseInterface {
    var exercises: [FTExercise] = []
    
    func create(data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        let exercise = FTExercise(id: UUID().uuidString, name: data.name, description: data.description, muscleKinds: data.muscleKinds, сomplexity: data.complexity, workoutId: data.workoutId)
        exercises.append(exercise)
        completion?(.success(exercise))
    }
    
    func get(exerciseId: String, completion: FTCompletion<FTExercise>) {
        let exercise = exercises.first(where: { $0.id == exerciseId })!
        completion?(.success(exercise))
    }
    
    func get(workoutId: String, completion: FTCompletion<[FTExercise]>) {
        let exercises = exercises.filter { $0.workoutId == workoutId }
        completion?(.success(exercises))
    }
    
    func update(exerciseId: String, data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        let index = exercises.firstIndex(where: { $0.id == exerciseId })!
        let oldExercise = exercises[index]
        let exercise = getExerciseFromCreate(data, id: exerciseId, workoutId: oldExercise.workoutId)
        exercises[index] = exercise
    }
    
    func delete(exerciseId: String, completion: FTCompletion<Void>) {}
    
    private func getExerciseFromCreate(_ data: FTExerciseCreate, id: String? = nil, workoutId: String? = nil) -> FTExercise {
        var newId = UUID().uuidString
        var workout: String = data.workoutId!
        if let id { newId = id }
        if let workoutId { workout = workoutId }
        let exercise = FTExercise(id: newId, name: data.name, description: data.description,
                                  muscleKinds: data.muscleKinds, сomplexity: data.complexity,
                                  statistics: [], workoutId: workout)
        return exercise
    }
}

class MockSetInterface: FTSetInterface {
    func create(data: FTSetCreate, completion: FTCompletion<FTSet>) {}
    
    func get(setId: String, completion: FTCompletion<FTSet>) {}
    
    func get(exerciseId: String, completion: FTCompletion<[FTSet]>) {}
    
    func edit(setId: String, newData data: FTSetCreate, completion: FTCompletion<FTSet>) {}
    
    func delete(setId: String, completion: FTCompletion<Void>) {}
    
    
}
