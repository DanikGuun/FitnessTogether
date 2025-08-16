
import UIKit
import FTDomainData

public final class WorkoutBuilderExerciseState: WorkoutBuilderState {
    
    public var delegate: (any ScreenStateDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    init() {
        setup()
    }
    
    public func apply(to workout: inout FTWorkout) {
        
    }
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, subtitleLabel]
    }
    
    private func setup() {
        setupTitle(titleLabel, text: "Конструктор тренировок")
        setupSubtitle()
    }
    
    private func setupTitle(_ label: UILabel, text: String = "") {
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .center
    }
    
    private func setupSubtitle() {
        subtitleLabel.font = DC.Font.additionalInfo
        subtitleLabel.textColor = .systemGray3
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Соберите тренировку"
    }
    
}
