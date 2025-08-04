
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
        for name in ["Здоровяк", "Громила", "Чертяга"] {
            //сам тренер
            var coach = FTUser(firstName: name, role: .coach, id: name)
            let pairs = clients.map { FTClientCoachPair(clientId: $0.id, client: $0, coachId: coach.id, coach: coach) }
            coach.clients = pairs
            coaches.append(coach)
            
            //его тренировки
            for _ in 0...15 {
                let date = refDate//Calendar.current.date(byAdding: .day, value: Int.random(in: 0..<7), to: refDate)
                let random = getRandomCurrentWeekDate(refDate)
                let type = FTWorkoutKind.allCases.randomElement()!
                var workout = FTWorkout(id: UUID().uuidString, startDate: random, endDate: random.addingTimeInterval(CGFloat.random(in: 0..<3*3600)), workoutKind: type)
                let client = clients.randomElement()!
                let part1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
                let part2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
                workout.participants = [part1, part2]
                workouts.append(workout)
            }
        }
        
        _workout.workouts = workouts
        _user.user = coaches.first!
    }
    
    private func getRandomCurrentWeekDate(_ refDate: Date) -> Date {
        let daysToAdd = Int.random(in: 0..<14).cgf
        let startWeek = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!.start
        var day = startWeek.addingTimeInterval(daysToAdd * 24.cgf * 3600.cgf)
        var startTime = CGFloat.random(in: 0..<21*3600)
        day = day.addingTimeInterval(startTime)
        return day
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
    
    init() {
        
    }
    
    public func create(data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) { }
    
    public func get(workoutId: String, completion: FTCompletion<FTWorkout>) { }
    
    public func getAll(completion: FTCompletion<[FTWorkout]>) {
        completion?(.success(workouts))
    }
    
    public func edit(workoutId: String, newData data: FTWorkoutCreate, completion: FTCompletion<FTWorkout>) { }
    
    public func delete(workoutId: String, completion: FTCompletion<Void>) { }
    
    
}

public class OfflineExerciseInterface: FTExerciseInterface {
    
    init() {
        
    }
    
    public func create(data: FTExerciseCreate, completion: FTCompletion<FTExercise>) { }
    
    public func get(exerciseId: String, completion: FTCompletion<FTExercise>) { }
    
    public func get(workoutId: String, completion: FTCompletion<[FTExercise]>) { }
    
    public func update(exerciseId: String, data: FTExerciseCreate, completion: FTCompletion<FTExercise>) { }
    
    public func delete(exerciseId: String, completion: FTCompletion<Void>) { }
    
    
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
