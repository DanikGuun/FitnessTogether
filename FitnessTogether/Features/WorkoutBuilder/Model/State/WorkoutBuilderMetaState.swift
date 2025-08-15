
import UIKit
import FTDomainData

public final class WorkoutBuilderMetaState: ScreenState {
    public var delegate: (any ScreenStateDelegate)?
    
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    private var workoutKindLabel = UILabel()
    private var workoutKindSelecter = WorkoutKindSelector()
    
    private var descriptionLabel = UILabel()
    private var descriptionTextView = AutoSizeTextView()
    
    private var dateTimeView = DateTimeView()
    
    private var selectClientLabel = UILabel()
    private var clientSelecter = ClientListCollectionView()
    private var clientDisclosureButton: DisclosureButton!
    
    private var nextButton = UIButton.ftFilled(title: "Далее")
    
    init() {
        setup()
    }
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, subtitleLabel, UIView.spaceView(20),
                workoutKindLabel, workoutKindSelecter, UIView.spaceView(DC.Layout.spacing),
                descriptionLabel, descriptionTextView, UIView.underlineView(), UIView.spaceView(DC.Layout.spacing),
                dateTimeView, UIView.spaceView(DC.Layout.spacing),
                selectClientLabel, clientSelecter, clientDisclosureButton, UIView.spaceView(DC.Layout.spacing),
                nextButton]
    }
    
    private func setup() {
        setupTitle(titleLabel, text: "Конструктор тренировок")
        setupSubtitle()
        setupTitle(workoutKindLabel, text: "Тип тренировки")
        setupWorkoutKindSelecter()
        setupTitle(descriptionLabel, text: "Описание ренировки")
        setupDescriptionTextView()
        setupDateTimeView()
        setupClientDisclosureButton()
        setupTitle(selectClientLabel, text: "Выберите ученика")
        nextButton.isEnabled = false
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
    
    private func setupWorkoutKindSelecter() {
        workoutKindSelecter.constraintHeight(28)
        workoutKindSelecter.selectedWorkoutKind = FTWorkoutKind.allCases.first ?? .none
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = DC.Font.roboto(weight: .regular, size: 14)
        descriptionTextView.isEditable = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = .zero
    }
    
    private func setupDateTimeView() {
        dateTimeView.dateHasChanged = { [weak self] _ in self?.checkNextButtonAvailable() }
    }
    
    private func setupClientDisclosureButton() {
        clientDisclosureButton = DisclosureButton(viewToDisclosure: clientSelecter)
        clientDisclosureButton.backgroundColor = .systemBackground
        clientSelecter.clientDidSelected = { [weak self] _ in self?.checkNextButtonAvailable() }
        setClientItems()
    }
    
    private func setClientItems() {
        var items: [ClientListItem] = []
        for i in 0...10 {
            items.append(ClientListItem(title: "title \(i)"))
        }
        clientSelecter.items = items
        clientDisclosureButton.updateViewHeight()
    }
    
    //MARK: - Validation
    private func checkNextButtonAvailable() {
        let available = dateTimeView.date != nil && clientSelecter.selectedItem != nil
        nextButton.isEnabled = available
    }
    
}
