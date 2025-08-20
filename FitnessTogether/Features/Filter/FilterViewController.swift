
import UIKit
import FTDomainData

public typealias WorkoutFilter = ((FTWorkout) -> Bool)

public protocol WorkoutFilterViewControllerDelegate {
    func workoutFilter(_ vc: UIViewController, didSelect filter: WorkoutFilter)
}

public final class WorkoutFilterViewController: FTViewController {
    var delegate: (any WorkoutFilterViewControllerDelegate)?
    
    var topBar = UIView()
    var dateIntervalSelecter = DateIntervalSelecterView()
    var workoutKindSelecter = WorkoutKindSelector()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        scrollView.backgroundColor = .secondarySystemBackground
        setupTopBar()
        addSpacing(.fixed(70))
        
        addTitle(title: "Выбрать период")
        addStackSubview(dateIntervalSelecter)
        addSpacing(.fixed(DC.Layout.spacing))
        
        
        addTitle(title: "Тип тренировки")
        addStackSubview(workoutKindSelecter)
        addSpacing(.fixed(DC.Layout.spacing))
        
        addTitle(title: "Дата")
        
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
    
    @discardableResult private func addTitle(title: String) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.roboto(weight: .semibold, size: 20)
        label.textAlignment = .left
        label.textColor = .label
        label.text = title
        addStackSubview(label)
        return label
    }
    
    //MARK: - Actions
    private func resetButtonPressed(_ action: UIAction?) {
        
    }
}


