
import FTDomainData

public final class EditWorkoutBuilderModel: BaseWorkoutBuilderModel {
    
    let editingWorkoutId: String
    var editingWorkout: FTWorkout?
    
    init(workoutId: String, ftManager: any FTManager) {
        self.editingWorkoutId = workoutId
        super.init(ftManager: ftManager)
        let metaState = states[0] as! WorkoutBuilderMetaState
        let exerciseState = states[1] as! WorkoutBuilderExerciseState
        setInitialData(metaState: metaState, exerciseState: exerciseState)
    }
    
    //MARK: - Start Data
    private func setInitialData(metaState: WorkoutBuilderMetaState, exerciseState: WorkoutBuilderExerciseState) {
        
        ftmanager.workout.get(workoutId: editingWorkoutId, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let workout):
                editingWorkout = workout
                metaState.workoutKindSelecter.selectedWorkoutKind = workout.workoutKind
                metaState.descriptionTextView.text = workout.description
                metaState.dateTimeView.date = workout.startDate
                print(workout.exercises)
                metaState.clientSelecter.selectClient(id: getClient(workout: workout))
                exerciseState.exercises = workout.exercises?.compactMap(getExerciseCreate) ?? []
                
                
            case .failure(let error):
                print("EditWorkoutBuilderModel " + error.localizedDescription)
            }
        })
    }
    
    private func getClient(workout: FTWorkout) -> String {
        guard let clientPart = workout.participants.first(where: { $0.role == .client }) else { return "" }
        return clientPart.userId
    }
    
    private func getExerciseCreate(exercise: FTExercise?) -> FTExerciseCreate? {
        guard let exercise else { return nil }
        return FTExerciseCreate(name: exercise.name, description: exercise.description, muscleKinds: exercise.muscleKinds, complexity: exercise.сomplexity, workoutId: exercise.workoutId)
    }
    
    //MARK: - Other
    public override func saveWorkoutAndExercises(completion: ((Result<Void, any Error>) -> (Void))?) {
        
    }
    
}
