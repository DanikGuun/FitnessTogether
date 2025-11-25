
import Foundation
import FTDomainData
import FTApi

public protocol FTManager {
    var email: FTEmailInterface { get }
    var user: FTUserInterface { get }
    var workout: FTWorkoutInterface { get }
    var exercise: FTExerciseInterface { get }
    var set: FTSetInterface { get }
}

public protocol FTEmailInterface {
    func forgotPassword(data: FTForgotPasswordEmail, completion: FTCompletion<FTResetCode>)
    func resetPassword(data: FTResetPassword, completion: FTCompletion<Void>)
    func isEmailAvailable(email: String, completion: FTCompletion<FTIsEmailAvailableData>)
}

public protocol FTUserInterface {
    var token: String? { get }
    var hasPreviousLogin: Bool { get }
    
    func register(data: FTUserRegister, completion: FTCompletion<Data>)
    func login(data: FTUserLogin, completion: FTCompletion<Data>)
    func loginWithPreviousCredentials(completion: FTCompletion<Data>)
    func logout(completion: FTCompletion<Void>)
    func deleteAccount(completion: FTCompletion<Void>)
    func current(completion: FTCompletion<FTUser>)
    func addClientToCoach(clientId: String, completion: FTCompletion<Void>)
    func getClients(completion: FTCompletion<[FTClientData]>)
    func getCoaches(completion: FTCompletion<[FTClientData]>)
    func get(id: String, completion: FTCompletion<FTClientData>)
}

public protocol FTWorkoutInterface {
    func create(data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>)
    func get(workoutId: String, completion: FTCompletion<FTWorkout>)
    func getAll(completion: FTCompletion<[FTWorkout]>)
    func edit(workoutId: String,newData data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>)
    func delete(workoutId: String, completion: FTCompletion<Void>)
}

public protocol FTExerciseInterface {
    func create(data: FTExerciseCreate, completion: FTCompletion<FTExercise>)
    func get(exerciseId: String, completion: FTCompletion<FTExercise>)
    func get(workoutId: String, completion: FTCompletion<[FTExercise]>)
    func update(exerciseId: String, data: FTExerciseCreate, completion: FTCompletion<FTExercise>)
    func delete(exerciseId: String, completion: FTCompletion<Void>)
}

public protocol FTSetInterface {
    func create(data: FTSetCreate, completion: FTCompletion<FTSet>)
    func get(setId: String, completion: FTCompletion<FTSet>)
    func get(exerciseId: String, completion: FTCompletion<[FTSet]>)
    func edit(setId: String, newData data: FTSetCreate, completion: FTCompletion<FTSet>)
    func delete(setId: String, completion: FTCompletion<Void>)
}
