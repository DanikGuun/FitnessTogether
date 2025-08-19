
import FTDomainData
import UIKit

public final class MuscleKindSelecter: FTButtonList {
    
    var selectionDidChange: (([FTMuscleKind]) -> Void)?
    var selectedMuscleKinds: [FTMuscleKind] {
        get { getSelectedMuscleKind() }
        set { select(newValue) }
    }
    
    override func setup() {
        super.setup()
        self.buttonConfigurationUpdateHandler = configurationUpdateHandler
        setupButtons()
    }
    
    public func select(_ kinds: [FTMuscleKind]) {
        let titles = kinds.map { $0.title }
        buttons.forEach { $0.isSelected = titles.contains($0.configuration?.title ?? "") }
    }
    
    private func configurationUpdateHandler(_ button: UIButton) {
        var conf = button.configuration ?? UIButton.Configuration.filled()
        
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
        for kind in FTMuscleKind.allCases {
            let button = UIButton(configuration: .filled())
            button.configuration?.title = kind.title
            button.configurationUpdateHandler = configurationUpdateHandler
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            buttons.append(button)
        }
        
        setButtons(buttons)
    }
    
    public override func setButtons(_ buttons: [UIButton]) {
        super.setButtons(buttons)
        buttons.forEach(setupMuscleKindSelecter)
    }
    
    private func setupMuscleKindSelecter(_ button: UIButton) {
        button.changesSelectionAsPrimaryAction = true
        button.makeCornerAndShadow(radius: 0, shadowRadius: 2, opacity: 0.2)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            selectionDidChange?(getSelectedMuscleKind())
        }), for: .touchUpInside)
    }
    
    private func getSelectedMuscleKind() -> [FTMuscleKind] {
        let selectedTitles = buttons.filter({ $0.isSelected }).map { $0.configuration?.title ?? "" }
        let selectedKinds = FTMuscleKind.allCases.filter { selectedTitles.contains($0.title) }
        return selectedKinds
    }
    
}
