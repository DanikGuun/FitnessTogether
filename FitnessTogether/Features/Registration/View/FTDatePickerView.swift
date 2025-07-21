
import UIKit
import Foundation

public final class FTDatePickerView: UIButton, UIPopoverPresentationControllerDelegate {
    
    public var date: Date? { didSet { dateHasBeenUpdated() } }
    public var isCorrectDate = true { didSet { setNeedsUpdateConfiguration() } }
    
    var calendarImageView = UIImageView()
    var dateFormat = "dd MMMM YYYY"
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setupSelf()
        setupCalendarImageView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateConfiguration()
    }
    
    //MARK: - Button
    private func setupSelf() {
        contentHorizontalAlignment = .leading
        configurationUpdateHandler = configurationUpdateHandler(_:)
        updateConfiguration()
        addAction(UIAction(handler: { [weak self] _ in
            self?.pushAlertDatePicker()
        }), for: .touchUpInside)
    }
    
    public func pushAlertDatePicker() {
        isCorrectDate = true
        superview?.endEditing(true)
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.permittedArrowDirections = [.up]
        vc.popoverPresentationController?.sourceView = self
        vc.popoverPresentationController?.delegate = self
        vc.preferredContentSize = CGSize(width: bounds.width, height: 200)
        
        let datePicker = makeDatePickerForAlert()
        vc.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        viewController?.present(vc, animated: true)
    }
    
    private func makeDatePickerForAlert() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale.actual
        datePicker.maximumDate = Date().addingTimeInterval(-3600 * 24 * 365 * 5) //5 лет
        datePicker.addAction(UIAction(handler: { [weak self] _ in
            self?.date = datePicker.date
        }), for: .valueChanged)
        return datePicker
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: - ImageView
    private func setupCalendarImageView() {
        addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.bottom.trailing.equalToSuperview().inset(DC.Layout.insets.top * 1.6)
            maker.trailing.equalToSuperview().inset(DC.Layout.insets.right)
            maker.width.equalTo(self.calendarImageView.snp.height).multipliedBy(0.9)
        }
        
        calendarImageView.image = UIImage(named: "Calendar")
    }
    
    private func configurationUpdateHandler(_ button: UIButton) {
        let isActive = date != nil
        var configuration = configuration ?? UIButton.Configuration.plain()
        configuration.contentInsets = DC.Layout.insets.nsInsets
        configuration.attributedTitle = getAttributedTitle()
        configuration.baseForegroundColor = chooseColor(isActive ? .label : .systemGray4)
        
        calendarImageView.tintColor = configuration.baseForegroundColor
         
        configuration.background.strokeWidth = 2
        configuration.background.strokeColor = chooseColor(isActive ? .ftOrange : .systemGray4)
        configuration.background.cornerRadius = DC.Size.buttonCornerRadius
        
        self.configuration = configuration
    }
    
    private func getAttributedTitle() -> AttributedString {
        let text = getTitle()
        let attributes = AttributeContainer([
            .font: DC.Font.textfield
        ])
        let string = AttributedString(text, attributes: attributes)
        return string
    }
    
    
    //MARK: - Other
    private func getTitle() -> String {
        guard let date else { return "Дата рождения" }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.actual
        let text = formatter.string(from: date)
        return text
    }
    
    private func chooseColor(_ color: UIColor) -> UIColor {
        if isCorrectDate == false { return .systemRed }
        let isOverlapsed = viewController?.isOverlapsed ?? false
        return isOverlapsed ? .systemGray4 : color
    }
    
    private func dateHasBeenUpdated() {
        setNeedsUpdateConfiguration()
        self.sendActions(for: .valueChanged)
    }
}
