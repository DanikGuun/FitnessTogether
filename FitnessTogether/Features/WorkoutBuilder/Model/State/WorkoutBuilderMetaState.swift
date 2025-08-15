
import UIKit

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
    
    private var nextButton = UIButton()
    
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
        workoutKindSelecter.constraintHeight(28)
        setupTitle(descriptionLabel, text: "Описание ренировки")
        setupDescriptionTextView()
        setupClientDisclosureButton()
        setupTitle(selectClientLabel, text: "Выберите ученика")
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
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = DC.Font.roboto(weight: .regular, size: 14)
        descriptionTextView.isEditable = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = .zero
    }
    
    private func setupClientDisclosureButton() {
        clientDisclosureButton = DisclosureButton(viewToDisclosure: clientSelecter)
        clientDisclosureButton.backgroundColor = .systemBackground
        setClientItems()
    }
    
    private func setClientItems() {
        var items: [ClientListItem] = []
        for i in 0...50 {
            items.append(ClientListItem(title: "title \(i)"))
        }
        clientSelecter.items = items
        clientDisclosureButton.updateViewHeight()
    }
    
}
