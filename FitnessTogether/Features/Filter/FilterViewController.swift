
import UIKit
import FTDomainData

public protocol WorkoutFilterViewControllerDelegate {
    func workoutFilterVC(_ vc: UIViewController, didSelect filterBag: FTFilterBag)
    func workoutFilterVCGetDefaultBag(_ vc: UIViewController) -> FTFilterBag //по умолчанию для сброса
    func workoutFilterVCGetInitialBag(_ vc: UIViewController) -> FTFilterBag //чтобы получить последний фильтр для открытия
    func workoutFilter(_ vc: UIViewController, getWorkoutsCountFor filterBag: FTFilterBag, completion: @escaping (Int) -> Void)
}

public final class WorkoutFilterViewController: FTViewController {
    public var delegate: (any WorkoutFilterViewControllerDelegate)?
    public var filterBag: FTFilterBag { get { getFilterBag() } set { setFilterBag(newValue) } }
    
    var topBar = UIView()
    var dateIntervalSelecter = DateIntervalSelecterView()
    var workoutKindSelecter = WorkoutKindSelector()
    var customDateStackView = UIStackView()
    var customDateIntervalTitle: UILabel!
    var startCustomDatePicker = FTDateButton()
    var endCustomDatePicker = FTDateButton()
    lazy var applyButton = UIButton.ftFilled(handler: applyButtonPressed)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        dateIntervalSelecter.selectedInterval = .month
        setupInitialFilterBag()
    }
    
    private func setup() {
        setupTopBar()
        setupScrollView()
        addSpacing(.fixed(70))
        
        addTitle(title: "Тип тренировки")
        setupWorkoutKindSelecter()
        addSpacing(.fixed(DC.Layout.spacing))
        
        addTitle(title: "Выбрать период")
        setupDateIntervalSelecter()
        addSpacing(.fixed(DC.Layout.spacing))
        
        customDateIntervalTitle = addTitle(title: "Пользовательский")
        setupCustomDatePicker()
        
        setupApplyButton()
    }
    
    private func setupTopBar() {
        let topBar = UIView()
        topBar.backgroundColor = .systemBackground
        view.addSubview(topBar)
        topBar.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(54)
        }
        
        let barTitle = UILabel.headline("Фильтр")
        topBar.addSubview(barTitle)
        barTitle.snp.makeConstraints { $0.center.equalToSuperview() }
        
        let resetButton = UIButton(configuration: .plain())
        topBar.addSubview(resetButton)
        resetButton.snp.makeConstraints { $0.centerY.trailing.equalToSuperview() }
        resetButton.tintColor = .ftOrange
        resetButton.setTitle("Сбросить", for: .normal)
        resetButton.addAction(UIAction(handler: resetButtonPressed), for: .touchUpInside)
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .secondarySystemBackground
        scrollView.snp.remakeConstraints { $0.edges.equalToSuperview() }
    }
    
    @discardableResult private func addTitle(title: String) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.roboto(weight: .semibold, size: 20)
        label.textAlignment = .left
        label.textColor = .label
        label.text = title
        addStackSubview(label)
        return label
    }
    
    private func setupWorkoutKindSelecter() {
        addStackSubview(workoutKindSelecter)
        workoutKindSelecter.addButton(withTitle: "Все", at: 0)
        workoutKindSelecter.addAction(UIAction(handler: workoutKindChanged), for: .valueChanged)
    }
    
    private func setupDateIntervalSelecter() {
        addStackSubview(dateIntervalSelecter)
        dateIntervalSelecter.addAction(UIAction(handler: dateIntervalChanged), for: .valueChanged)
    }
    
    private func setupCustomDatePicker() {
        customDateStackView.axis = .horizontal
        customDateStackView.distribution = .equalSpacing
        customDateStackView.spacing = 8
        
        let fromLabel = UILabel()
        fromLabel.font = DC.Font.roboto(weight: .regular, size: 16)
        fromLabel.text = "с"
        customDateStackView.addArrangedSubview(fromLabel)
        customDateStackView.addArrangedSubview(startCustomDatePicker)
        startCustomDatePicker.addAction(UIAction(handler: startCustomIntervalChanged), for: .valueChanged)
        
        let toLabel = UILabel()
        fromLabel.font = DC.Font.roboto(weight: .regular, size: 16)
        toLabel.text = "по"
        customDateStackView.addArrangedSubview(toLabel)
        customDateStackView.addArrangedSubview(endCustomDatePicker)
        endCustomDatePicker.maximumDate = Date()
        endCustomDatePicker.addAction(UIAction(handler: endCustomIntervalChanged), for: .valueChanged)
        
        addStackSubview(customDateStackView)
    }
    
    private func setupApplyButton() {
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(44)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().inset(24)
        }
        
    }
    
    //MARK: - Actions
    private func resetButtonPressed(_ action: UIAction?) {
        guard let delegate else { return }
        filterBag = delegate.workoutFilterVCGetDefaultBag(self)
        dateIntervalChanged(nil)
    }
    
    private func workoutKindChanged(_ action: UIAction?) {
        filterBagDidChange()
    }
    
    private func dateIntervalChanged(_ action: UIAction?) {
        var height: CGFloat = 0
        if case .custom(_) = dateIntervalSelecter.selectedInterval {
            height = 47
        }
        let labelHeight = min(height, customDateIntervalTitle.intrinsicContentSize.height)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            customDateStackView.constraintHeight(height)
            customDateIntervalTitle.constraintHeight(labelHeight)
            scrollView.layoutIfNeeded()
        })
        filterBagDidChange()
    }
    
    private func startCustomIntervalChanged(_ action: UIAction?) {
        filterBagDidChange()
    }
    
    private func endCustomIntervalChanged(_ action: UIAction?) {
        startCustomDatePicker.maximumDate = endCustomDatePicker.date
        filterBagDidChange()
    }
    
    private func applyButtonPressed(_ action: UIAction?) {
        let bag = getFilterBag()
        delegate?.workoutFilterVC(self, didSelect: bag)
        dismiss(animated: true)
    }
    
    //MARK: - Filter bag managment
    func getFilterBag() -> FTFilterBag {
        var bag = FTFilterBag()
        bag.workoutKind = workoutKindSelecter.selectedWorkoutKind
        
        if case .custom(_) = dateIntervalSelecter.selectedInterval {
            let start = startCustomDatePicker.date
            let end = endCustomDatePicker.date
            bag.dateInterval = .custom(DateInterval(start: start, end: end))
        }
        else {
            bag.dateInterval = dateIntervalSelecter.selectedInterval
        }
        return bag
    }
    
    func setFilterBag(_ bag: FTFilterBag) {
        workoutKindSelecter.selectedWorkoutKind = bag.workoutKind
        if bag.workoutKind == nil {
            workoutKindSelecter.selectButton(at: 0)
        }

        
        if case .custom(let interval) = bag.dateInterval {
            dateIntervalSelecter.selectedInterval = .custom(interval)
            startCustomDatePicker.date = interval.start
            endCustomDatePicker.date = interval.end
        }
        else {
            dateIntervalSelecter.selectedInterval = bag.dateInterval
        }
        
        filterBagDidChange()
    }
    
    private func filterBagDidChange() {
        let bag = getFilterBag()
        delegate?.workoutFilter(self, getWorkoutsCountFor: bag) { [weak self] count in
            self?.applyButton.configuration?.title = "Показать \(count) тренировок"
        }
    }
    
    func setupInitialFilterBag() {
        guard let bag = delegate?.workoutFilterVCGetInitialBag(self) else { return }
        filterBag = bag
        //для полного обновления
        dateIntervalChanged(nil)
        startCustomIntervalChanged(nil)
        endCustomIntervalChanged(nil)
        workoutKindChanged(nil)
        filterBagDidChange()
    }
    
    
}

public extension WorkoutFilterViewControllerDelegate {
    func workoutFilterVC(_ vc: UIViewController, didSelect filterBag: FTFilterBag) {}
    func workoutFilterVCGetDefaultBag(_ vc: UIViewController) -> FTFilterBag { return FTFilterBag() }
    func workoutFilterVCGetInitialBag(_ vc: UIViewController) -> FTFilterBag { return FTFilterBag() }
    func workoutFilter(_ vc: UIViewController, getWorkoutsCountFor filterBag: FTFilterBag, completion: @escaping (Int) -> Void) {}
}
