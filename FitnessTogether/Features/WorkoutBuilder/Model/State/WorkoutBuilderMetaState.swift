
import UIKit
import FTDomainData

public final class WorkoutBuilderMetaState: WorkoutBuilderState {
    public var delegate: (any ScreenStateDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    var workoutKindLabel = UILabel()
    var workoutKindSelecter = WorkoutKindSelector()
    
    var descriptionLabel = UILabel()
    var descriptionTextView = AutoSizeTextView()
    
    var dateTimeView = DateTimeView()
    
    var selectClientLabel = UILabel()
    var clientSelecter = ClientListCollectionView()
    var clientDisclosureButton: DisclosureButton!
    
    var nextButton = UIButton.ftFilled(title: "Далее")
    
    public func apply(to workout: inout FTWorkout) {
        workout.workoutKind = workoutKindSelecter.selectedWorkoutKind
        workout.description = descriptionTextView.text ?? ""
        workout.startDate = dateTimeView.date
        workout.participants.append(FTWorkoutParticipant(workoutId: workout.id, userId: clientSelecter.selectedItem?.id ?? "", role: .client))
    }
    
    init() {
        setup()
        //TODO: - Убрать
        dateTimeView.date = Date()
        clientSelecter.selectClient(id: clientSelecter.items.first!.id)
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
        setupTitle(workoutKindLabel, text: "Тип")
        setupWorkoutKindSelecter()
        setupTitle(descriptionLabel, text: "Описание")
        setupDescriptionTextView()
        setupDateTimeView()
        setupClientDisclosureButton()
        setupTitle(selectClientLabel, text: "Выберите ученика")
        setupNextButton()
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
    
    private func setupNextButton() {
        nextButton.isEnabled = false
        nextButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            delegate?.screenStateGoNext(self)
        }), for: .touchUpInside)
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
