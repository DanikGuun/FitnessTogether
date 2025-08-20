
import FTDomainData
import UIKit

public final class MuscleKindSelecter: FTButtonList {
    
    var selectedMuscleKinds: [FTMuscleKind] {
        get { getSelectedMuscleKind() }
        set { select(newValue) }
    }
    
    override func setup() {
        super.setup()
        setupButtons()
    }
    
    public func select(_ kinds: [FTMuscleKind]) {
        let titles = kinds.map { $0.title }
        buttons.forEach { $0.isSelected = titles.contains($0.configuration?.title ?? "") }
    }
    
    private func setupButtons() {
        let titles = FTMuscleKind.allCases.map { $0.title }
        setButtons(titles: titles)
    }
    
    override func setupButton(_ button: UIButton) {
        super.setupButton(button)
        button.changesSelectionAsPrimaryAction = true
    }
    
    override func buttonPressed(_ action: UIAction) {
        super.buttonPressed(action)
        sendActions(for: .valueChanged)
    }
    
    private func getSelectedMuscleKind() -> [FTMuscleKind] {
        let selectedTitles = buttons.filter({ $0.isSelected }).map { $0.configuration?.title ?? "" }
        let selectedKinds = FTMuscleKind.allCases.filter { selectedTitles.contains($0.title) }
        return selectedKinds
    }
    
}
