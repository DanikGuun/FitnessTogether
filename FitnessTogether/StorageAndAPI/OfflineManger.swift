
import FTDomainData
import Foundation

public class OfflineManger: FTManager {
    public var user: any FTUserInterface { _user }
    public var workout: any FTWorkoutInterface { _workout }
    public var exercise: any FTExerciseInterface { _exercise }
    public var set: any FTSetInterface { _set }
    
    var _user = OfflineUserInterface()
    var _workout = OfflineWorkoutInterface()
    var _exercise = OfflineExerciseInterface()
    var _set = OfflineSetInterface()
    
    init() {
        setupWorkoutsList()
    }
    
    private func setupWorkoutsList() {
        let refDate = Date()
        var clients: [FTUser] = []
        for name in ["Антон", "Егор", "Пиздюк"] {
            let client = FTUser(firstName: name, role: .client, id: name)
            clients.append(client)
        }
        
        var coaches: [FTUser] = []
        var workouts: [FTWorkout] = []
        for name in ["Здоровяк"] { //, "Громила", "Чертяга"
            //сам тренер
            var coach = FTUser(firstName: name, role: .coach, id: name)
            let pairs = clients.map { FTClientCoachPair(clientId: $0.id, client: $0, coachId: coach.id, coach: coach) }
            coach.clients = pairs
            coaches.append(coach)
            
            //его тренировки
            for _ in 0...1 {
                let date = refDate//Calendar.current.date(byAdding: .day, value: Int.random(in: 0..<7), to: refDate)
                let random = getRandomCurrentWeekDate(refDate)
                let type = FTWorkoutKind.allCases.randomElement()!
                var workout = FTWorkout(id: UUID().uuidString, startDate: random, duration: 5400, workoutKind: type)
                let client = clients.randomElement()!
                let part1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
                let part2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
                workout.participants = [part1, part2]
                let exersies = getRandomExercises(for: workout)
                workout.exercises = exersies
                workouts.append(workout)
                _exercise.exercises += exersies
            }
        }
        
        _workout.workouts = workouts
        _workout.coachId = coaches.first!.id
        _user.user = coaches.first!
    }
    
    private func getRandomCurrentWeekDate(_ refDate: Date) -> Date {
        let daysToAdd = Int.random(in: 0..<7).cgf
        let startWeek = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!.start
        var day = startWeek.addingTimeInterval(daysToAdd * 24.cgf * 3600.cgf)
        let startTime = CGFloat.random(in: 0..<21*3600)
        day = day.addingTimeInterval(startTime)
        return day
    }
    
    private func getRandomExercises(for workout: FTWorkout) -> [FTExercise] {
        var exercieses: [FTExercise] = []
        for _ in 0..<10 {
            let ex = FTExercise(id: UUID().uuidString, name: "WorkoutName", description: "Some description", muscleKinds: [.abs, .biceps], сomplexity: .hard, statistics: [], workoutId: workout.id, workout: workout)
            exercieses.append(ex)
        }
        return exercieses
    }
    
}

public class OfflineUserInterface: FTUserInterface {
    public var token: String?
    public var hasPreviousLogin: Bool = false
    
    var user: FTUser?
    
    init() {
        
    }
    
    public func register(data: FTUserRegister, completion: FTCompletion<Data>) {
        completion?(.success(Data()))
    }
    
    public func login(data: FTUserLogin, completion: FTCompletion<Data>) {
        completion?(.success(Data()))
    }
    
    public func loginWithPreviousCredentials(completion: FTCompletion<Data>) { }
    
    public func logout(completion: FTCompletion<Void>) { }
    
    public func current(completion: FTCompletion<FTUser>) {
        completion?(.success(user ?? FTUser()))
    }
    
    public func addClientToCoach(clientId: String, completion: FTCompletion<Void>) { }
    
    public func getClients(completion: FTCompletion<[FTUser]>) {
        let clients = user?.clients.map { $0.client }
        completion?(.success(clients ?? []))
    }
    
    
}

public class OfflineWorkoutInterface: FTWorkoutInterface {
    
    var workouts: [FTWorkout] = []
    var coachId: String = ""
    
    init() {
        
    }
    
    public func create(data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        let workout = getWorkoutFromCreate(data)
        workouts.append(workout)
        completion?(.success(workout))
    }
    
    public func get(workoutId: String, completion: FTCompletion<FTWorkout>) {
        if let workout = workouts.first(where: { $0.id == workoutId }) {
            completion?(.success(workout))
        }
    }
    
    public func getAll(completion: FTCompletion<[FTWorkout]>) {
        completion?(.success(workouts))
    }
    
    public func edit(workoutId: String, newData data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) {
        guard let index = workouts.firstIndex(where: { $0.id == workoutId }) else { return }
        let workout = getWorkoutFromCreate(data, id: workoutId)
        workouts[index] = workout
        completion?(.success(workout))
    }
    
    public func delete(workoutId: String, completion: FTCompletion<Void>) { }
    
    private func getWorkoutFromCreate(_ workout: FTWorkoutCreate, id: String? = nil) -> FTWorkout {
        var newId = UUID().uuidString
        if let id { newId = id }
        let formatter = ISO8601DateFormatter()
        let part = FTWorkoutParticipant(workoutId: newId, userId: workout.userId, role: .client)
        let part2 = FTWorkoutParticipant(workoutId: newId, userId: coachId, role: .coach)
        let newWorkout = FTWorkout(id: newId, description: workout.description, startDate: formatter.date(from: workout.startDate), duration: 5400, participants: [part, part2])
        return newWorkout
    }
    
}

public class OfflineExerciseInterface: FTExerciseInterface {
    
    var exercises: [FTExercise] = []
    
    init() {
        
    }
    
    public func create(data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        let exercise = getExerciseFromCreate(data)
        exercises.append(exercise)
    }
    
    public func get(exerciseId: String, completion: FTCompletion<FTExercise>) {
        guard let exercise = exercises.first(where: { $0.id == exerciseId }) else { return }
        completion?(.success(exercise))
    }
    
    public func get(workoutId: String, completion: FTCompletion<[FTExercise]>) {
        let exercises = exercises.filter { $0.workoutId == workoutId }
        completion?(.success(exercises))
    }
    
    public func update(exerciseId: String, data: FTExerciseCreate, completion: FTCompletion<FTExercise>) {
        let index = exercises.firstIndex(where: { $0.id == exerciseId })!
        let exercise = getExerciseFromCreate(data, id: exerciseId)
        exercises[index] = exercise
    }
    
    public func delete(exerciseId: String, completion: FTCompletion<Void>) { }
    
    private func getExerciseFromCreate(_ data: FTExerciseCreate, id: String? = nil) -> FTExercise {
        var newId = UUID().uuidString
        if let id { newId = id }
        let exercise = FTExercise(id: newId, name: data.name, description: data.description,
                                  muscleKinds: data.muscleKinds, сomplexity: data.complexity,
                                  statistics: [], workoutId: data.workoutId)
        return exercise
    }
    
}

public class OfflineSetInterface: FTSetInterface {
    
    init() {
        
    }
    
    public func create(data: FTSetCreate, completion: FTCompletion<FTSet>) { }
    
    public func get(setId: String, completion: FTCompletion<FTSet>) { }
    
    public func get(exerciseId: String, completion: FTCompletion<[FTSet]>) { }
    
    public func edit(setId: String, newData data: FTSetCreate, completion: FTCompletion<FTSet>) { }
    
    public func delete(setId: String, completion: FTCompletion<Void>) { }
    
    
}
