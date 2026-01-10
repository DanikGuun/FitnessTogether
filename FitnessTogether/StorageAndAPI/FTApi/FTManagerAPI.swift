
import FTApi
import FTDomainData
import Foundation

public final class FTManagerAPI: FTManager {

    public var email: any FTEmailInterface
    public var user: any FTUserInterface
    public var workout: any FTWorkoutInterface
    public var exercise: any FTExerciseInterface
    public var set: any FTSetInterface
    public var workoutAnalysis: any FTWorkoutAnalysisInterface
    
    public init() {
        let api = FTApi()
        email = FTEmailApiAdapter(emailAPI: api.email)
        user = FTUserApiAdapter(userAPI: api.user)
        workout = FTWorkoutApiAdapter(workoutAPI: api.workout)
        exercise = FTExerciseApiAdapter(exerciseAPI: api.exercise)
        set = FTSetApiAdapter(setAPI: api.set)
        workoutAnalysis = FTWorkoutAnalysisApiAdapter(workoutAnalysisAPI: api.workoutAnalysis)
    }
    
}

fileprivate final class FTEmailApiAdapter: FTEmailInterface {

    var emailAPI: FTEmailManager
    
    init(emailAPI: FTEmailManager) {
        self.emailAPI = emailAPI
    }
    
    func forgotPassword(data: FTForgotPasswordEmail, completion: FTCompletion<FTResetCode>) {
        emailAPI.forgotPassword(data: data, completion: completion)
    }
    
    func resetPassword(data: FTResetPassword, completion: FTCompletion<Void>) {
        emailAPI.resetPassword(data: data, completion: completion)
    }
    
    func isEmailAvailable(email: String, completion: FTCompletion<FTIsEmailAvailableData>) {
        emailAPI.isEmailAvailable(email: email, completion: completion)
    }
}

fileprivate final class FTUserApiAdapter: FTUserInterface {
    var userAPI: FTUserManager
    var token: String? { userAPI.token }
    var hasPreviousLogin: Bool { userAPI.hasPreviousLogin }
    
    init(userAPI: FTUserManager) {
        self.userAPI = userAPI
    }
    
    func register(data: FTUserRegister, completion: FTCompletion<Data>) {
        userAPI.register(data: data, completion: completion)
    }
    
    func login(data: FTUserLogin, completion: FTCompletion<Data>) {
        userAPI.login(data: data, completion: completion)
    }
    
    func loginWithPreviousCredentials(completion: FTCompletion<Data>) {
        userAPI.loginWithPreviousCredentials(completion: completion)
    }
    
    func logout(completion: FTCompletion<Void>) {
        userAPI.logout(completion: completion)
    }
    
    func deleteAccount(completion: FTCompletion<Void>) {
        userAPI.deleteAccount(completion: completion)
    }
    
    func current(completion: FTCompletion<FTUser>) {
        userAPI.current(completion: completion)
    }
    
    func addClientToCoach(clientId: String, completion: FTCompletion<Void>) {
        userAPI.addClientToCoach(clientId: clientId, completion: completion)
    }
    
    func getClients(completion: FTCompletion<[FTClientData]>) {
        userAPI.getClients(completion: completion)
    }
    
    func getCoaches(completion: FTCompletion<[FTClientData]>) {
        userAPI.getCoaches(completion: completion)
    }
    
    func get(id: String, completion: FTCompletion<FTClientData>) {
        userAPI.get(id: id, completion: completion)
    }
    
}

fileprivate final class FTWorkoutApiAdapter: FTWorkoutInterface {
    
    var workoutAPI: FTWorkoutManager
    
    init(workoutAPI: FTWorkoutManager) {
        self.workoutAPI = workoutAPI
    }

    func create(data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        workoutAPI.create(data: data, completion: completion)
    }
    
    func get(workoutId: String, completion: FTCompletion<FTWorkout>) {
        workoutAPI.get(workoutId: workoutId, completion: completion)
    }
    
    func getAll(completion: FTCompletion<[FTWorkout]>) {
        workoutAPI.getAll(completion: completion)
    }
    
    func edit(workoutId: String, newData data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        workoutAPI.edit(workoutId: workoutId, newData: data, completion: completion)
    }
    
    func delete(workoutId: String, completion: FTCompletion<Void>) {
        workoutAPI.delete(workoutId: workoutId, completion: completion)
    }
    
}

fileprivate final class FTExerciseApiAdapter: FTExerciseInterface {
    
    var exerciseAPI: FTExerciseManager
    
    init(exerciseAPI: FTExerciseManager) {
        self.exerciseAPI = exerciseAPI
    }
    
    func create(data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        exerciseAPI.create(data: data, completion: completion)
    }
    
    func get(exerciseId: String, completion: FTCompletion<FTExercise>) {
        exerciseAPI.get(exerciseId: exerciseId, completion: completion)
    }
    
    func get(workoutId: String, completion: FTCompletion<[FTExercise]>) {
        exerciseAPI.get(workoutId: workoutId, completion: completion)
    }
    
    func update(exerciseId: String, data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        exerciseAPI.update(exerciseId: exerciseId, data: data, completion: completion)
    }
    
    func delete(exerciseId: String, completion: FTCompletion<Void>) {
        exerciseAPI.delete(exerciseId: exerciseId, completion: completion)
    }
    
}

fileprivate final class FTSetApiAdapter: FTSetInterface {
    
    var setAPI: FTSetManager
    
    init(setAPI: FTSetManager) {
        self.setAPI = setAPI
    }
    
    func create(data: FTSetCreate, completion: FTCompletion<FTSet>) {
        setAPI.create(data: data, completion: completion)
    }
    
    func get(setId: String, completion: FTCompletion<FTSet>) {
        setAPI.get(setId: setId, completion: completion)
    }
    
    func get(exerciseId: String, completion: FTCompletion<[FTSet]>) {
        setAPI.get(exerciseId: exerciseId, completion: completion)
    }
    
    func edit(setId: String, newData data: FTSetCreate, completion: FTCompletion<FTSet>) {
        setAPI.edit(setId: setId, newData: data, completion: completion)
    }
    
    func delete(setId: String, completion: FTCompletion<Void>) {
        setAPI.delete(setId: setId, completion: completion)
    }
    
}

fileprivate final class FTWorkoutAnalysisApiAdapter: FTWorkoutAnalysisInterface {
    
    var workoutAnalysisAPI: FTWorkoutAnalysisManager
    
    init(workoutAnalysisAPI: FTWorkoutAnalysisManager) {
        self.workoutAnalysisAPI = workoutAnalysisAPI
    }
    
    func post(completion: FTCompletion<Void>) {
        workoutAnalysisAPI.Analyze(completion: completion)
    }
    
    func get(userId: String, completion: FTCompletion<[FTUserWorkoutAnalysis]>) {
        workoutAnalysisAPI.GetByUserId(userId: userId, completion: completion)
    }

}

