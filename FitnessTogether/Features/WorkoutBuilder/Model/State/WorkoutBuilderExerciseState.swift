
import UIKit
import FTDomainData

public final class WorkoutBuilderExerciseState: WorkoutBuilderState {
    
    public var delegate: (any ScreenStateDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var exerciseCollectionView = ExerciseCollectionView()
    var disclosureButton: DisclosureButton!
    
    var addExerciseButton = UIButton.ftPlain(title: "Добавить упражнение")
    var addWorkoutButton = UIButton.ftFilled(title: "Добавить тренировку")
    
    init() {
        setup()
    }
    
    public func apply(to workout: inout FTWorkout) {
        
    }
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, subtitleLabel, exerciseCollectionView, disclosureButton, addExerciseButton, addWorkoutButton]
    }
    
    private func setup() {
        setupTitle(titleLabel, text: "Конструктор тренировок")
        setupSubtitle()
        setupDisclosureButton()
        
        var items: [ExerciseCollectionItem] = []
        for title in 0..<3 {
            let item = ExerciseCollectionItem(title: "title \(title)", image: UIImage(systemName: "trash"))
            items.append(item)
        }
        exerciseCollectionView.items = items
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
    
    private func setupDisclosureButton() {
        disclosureButton = DisclosureButton(viewToDisclosure: exerciseCollectionView)
        disclosureButton.backgroundColor = .systemBackground
    }
    
}
