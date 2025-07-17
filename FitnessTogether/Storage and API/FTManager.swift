
import Foundation

protocol FTInterface {
    
    var user: FTUserInterface { get }
    var workout: FTWorkoutInterface { get }
    var exercise: FTExerciseInterface { get }
    var set: FTSetInterface { get }
    
}

protocol FTUserInterface {}
protocol FTWorkoutInterface {}
protocol FTExerciseInterface {}
protocol FTSetInterface {}
