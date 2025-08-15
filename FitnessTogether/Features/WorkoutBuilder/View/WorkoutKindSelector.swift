
import UIKit
import FTDomainData

public final class WorkoutKindSelector: FTButtonList {
    
    public var selectedWorkoutKind: FTWorkoutKind = .none { didSet { selectButton(for: selectedWorkoutKind) } }
    
    override func setup() {
        super.setup()
        self.buttonConfigurationUpdateHandler = configurationUpdateHandler
        setupButtons()
    }
    
    private func configurationUpdateHandler(_ button: UIButton) {
        var conf = button.configuration ?? UIButton.Configuration.plain()
        
        conf.baseBackgroundColor = .systemBackground
        conf.baseForegroundColor = .label
        
        conf.background.strokeColor = button.isSelected ? .ftOrange : .clear
        conf.background.strokeWidth = 1
        conf.background.cornerRadius = 8
        conf.contentInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10).nsInsets
        
        button.configuration = conf
    }
    
    private func setupButtons() {
        var buttons: [UIButton] = []
        for title in FTWorkoutKind.allCases.map({ $0.title }) {
            let button = UIButton(configuration: .filled())
            button.configuration?.title = title
            buttons.append(button)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        setButtons(buttons)
    }
    
    public override func setButtons(_ buttons: [UIButton]) {
        super.setButtons(buttons)
        buttons.forEach(setupWorkoutKindButton)
    }
    
    private func setupWorkoutKindButton(_ button: UIButton) {
        button.makeCornerAndShadow(radius: 0, shadowRadius: 2, opacity: 0.2)
        button.changesSelectionAsPrimaryAction = true
        button.addAction(UIAction(handler: workoutKindButtonPressed), for: .touchUpInside)
    }
    
    private func workoutKindButtonPressed(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        buttons.forEach { $0.isSelected = $0 == button }
        
        let title = button.configuration?.title
        let workoutKind = FTWorkoutKind.allCases.first(where: { $0.title.lowercased() == title?.lowercased() }) ?? .none
        selectedWorkoutKind = workoutKind
    }
    
    private func selectButton(for workoutKind: FTWorkoutKind) {
        let title = workoutKind.title
        buttons.forEach { $0.isSelected = $0.configuration?.title == title }
    }
    
}
