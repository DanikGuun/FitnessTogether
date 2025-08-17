

import FTDomainData
import Foundation
import UIKit

public final class ClientMainModel: BaseMainModel {

    public override func workoutsToItems(_ workouts: [FTWorkout], completion: @escaping ([WorkoutItem]) -> Void) {
        
        let items: [WorkoutItem] = workouts.compactMap { workout in
            let id = workout.id
            let image = UIImage(systemName: "person.crop.circle")
            let title = workout.workoutKind.title
            let date = workout.startDate ?? Date()
            let item = WorkoutItem(id: id, image: image, name: title, date: date)
            return item
            
        }
        
        completion(items)
    }
    
}
