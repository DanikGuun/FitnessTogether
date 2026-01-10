//
//  WorkoutAnalysisModel.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import FTDomainData


public protocol WorkoutAnalysisModel {
    func getWorkoutAnalysis(completion: @escaping ([FTUserWorkoutAnalysis]) -> Void)
}

public final class BaseWorkoutAnalysisModel: WorkoutAnalysisModel {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }

    public func getWorkoutAnalysis(completion: @escaping ([FTUserWorkoutAnalysis]) -> Void) {
        ftManager.user.current { [weak self] currentResult in
            guard let userId = try? currentResult.get().id else { return }
            
            self?.ftManager.workoutAnalysis.get(userId: userId, completion: { workoutAnalysisResult in
                switch workoutAnalysisResult {
                    
                case .success(let userWorkoutAnalysis):
                    completion(userWorkoutAnalysis)

                case .failure(let error):
                    print(error.localizedDescription)
                    ErrorPresenter.present(error)
                }
            })
        }
    }
}
