
import UIKit
import FTDomainData

public final class WorkoutKindSelector: FTButtonList {
    
    public var selectedWorkoutKind: FTWorkoutKind? = FTWorkoutKind.none { didSet { selectButton(for: selectedWorkoutKind) } }
    
    override func setup() {
        super.setup()
        setupButtons()
    }
    
    
    private func setupButtons() {
        let titles = FTWorkoutKind.allCases.map { $0.title }
        setButtons(titles: titles)
    }
    
    override func setupButton(_ button: UIButton) {
        super.setupButton(button)
        button.changesSelectionAsPrimaryAction = true
    }
    
    internal override func buttonPressed(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        
        let title = button.configuration?.title
        let workoutKind = FTWorkoutKind.allCases.first(where: { $0.title.lowercased() == title?.lowercased() })
        selectedWorkoutKind = workoutKind
        buttons.forEach { $0.isSelected = $0 == button }
        sendActions(for: .valueChanged)
    }
    
    private func selectButton(for workoutKind: FTWorkoutKind?) {
        let title = workoutKind?.title ?? ""
        buttons.forEach { $0.isSelected = $0.configuration?.title == title }
    }
    
    public override func selectButton(at index: Int) {
        super.selectButton(at: index)
        sendActions(for: .valueChanged)
    }
    
}
