
import FTDomainData

public final class CreateWorkoutBuilderModel: WorkoutBuilderModel {
    
    public private(set) var currentState = -1
    let states: [any WorkoutBuilderState]
    
    var ftmanager: FTManager
    var workout = FTWorkoutCreate()
    var exercises: [FTExerciseCreate] = []
    
    init(ftManager: FTManager) {
        self.ftmanager = ftManager
        states = [
            WorkoutBuilderMetaState(),
            WorkoutBuilderExerciseState()
        ]
    }
    
    public func getNextState() -> (any ScreenState)? {
        applyDataIfNeeded()
        guard currentState < states.count - 1 else { return nil }
        currentState += 1
        return states[safe: currentState]
    }
    
    public func getPreviousState() -> (any ScreenState)? {
        guard currentState > 0 else { return nil }
        currentState -= 1
        return states[safe: currentState]
    }
    
    internal func applyDataIfNeeded() {
        guard let state = states[safe: currentState] else { return }
        state.apply(workoutCreate: &workout, exercises: &exercises)
    }
    
    public func addWorkoutAndExercises(completion: ((Result<Void, Error>) -> (Void))?) {
        completion?(.success(Void()))
        getUserId(resultCompletion: completion) { [weak self] userId in
            guard let self else { return }
            workout.userId = userId
            
            addWorkout(resultCompletion: completion) { workout in
                for i in 0..<self.exercises.count {
                    self.exercises[i].workoutId = workout.id
                }
                
                self.addExercises(resultCompletion: completion) { result in
                    switch result {
                    case .success(): completion?(.success(Void()))
                    case .failure(let error): completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    private func getUserId(resultCompletion: ((Result<Void, Error>) -> (Void))?, completion: @escaping (String) -> (Void)) {
        ftmanager.user.current { result in
            switch result {
                
            case .success(let user):
                completion(user.id)
                
            case .failure(let error):
                resultCompletion?(.failure(error))
            }
            
        }
    }
    
    private func addWorkout(resultCompletion: ((Result<Void, Error>) -> (Void))?, completion: @escaping ((FTWorkout) -> (Void))) {
        ftmanager.workout.create(data: workout, completion: { result in
            switch result {
                
            case .success(let workout):
                completion(workout)
                
            case .failure(let error):
                resultCompletion?(.failure(error))
            }
        })
    }
    
    private func addExercises(resultCompletion: ((Result<Void, Error>) -> (Void))?, completion: @escaping (Result<Void, Error>) -> (Void)) {
        var count = 0
        for exercise in exercises {
            ftmanager.exercise.create(data: exercise, completion: { result in
                switch result {
                case .success(let exercise):
                    count += 1
                    if count == self.exercises.count {
                        completion(.success(()))
                    }
                    
                case .failure(let error):
                    resultCompletion?(.failure(error))
                    return
                }
            })
        }
    }
    
}
