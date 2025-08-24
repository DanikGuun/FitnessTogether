
import UIKit

public final class DateIntervalSelecterView: FTButtonList {
    
    public var selectedInterval: FTFilterDateInterval {
        get {
            let selectedIndex = buttons.firstIndex(where: { $0.isSelected == true }) ?? 0
            return FTFilterDateInterval.allCases[selectedIndex]
        }
        set {
            selectInterval(interval: newValue)
        }
    }
    
    override func setup() {
        super.setup()
        setupButtons()
    }
    
    //MARK: - Buttons
    private func setupButtons() {
        let titles = FTFilterDateInterval.allCases.map { $0.title }
        setButtons(titles: titles)
        selectInterval(interval: .week)
    }
    
    override func setupButton(_ button: UIButton) {
        super.setupButton(button)
        button.changesSelectionAsPrimaryAction = true
    }
    
    override func buttonPressed(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        buttons.forEach { $0.isSelected = $0 == button }
        
        sendActions(for: .valueChanged)
    }

    //MARK: - Actions
    private func selectInterval(interval: FTFilterDateInterval) {
        let title = interval.title
        buttons.forEach { $0.isSelected = $0.configuration?.title == title }
    }
    
}
