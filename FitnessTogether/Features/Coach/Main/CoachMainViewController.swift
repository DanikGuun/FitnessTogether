
import UIKit

public final class CoachMainViewController: FTViewController {
    
    private var trainsCollection: CoachTrainsView = CoachTrainsCollectionView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        addStackSubview(UILabel.headline("Ближайшие тренировки"))
        setupTrainsCollectionView()
        setupAddWorkoutButton()
    }
    
    private func setupTrainsCollectionView() {
        addStackSubview(trainsCollection, height: 200)
        trainsCollection.items = [
            CoachTrainItem(image: UIImage(systemName: "circle.fill"), name: "Александр Поп", date: Date()),
            CoachTrainItem(image: UIImage(systemName: "folder.circle.fill"), name: "джовани", date: Date()),
            CoachTrainItem(image: UIImage(systemName: "person.circle.fill"), name: "Елдыбухтардындырханым", date: Date()),
        ]
    }
    
    private func setupAddWorkoutButton() {
        let button = UIButton.ftFilled(title: "Добавить тренировку")
        addStackSubview(button)
        button.addAction(UIAction(handler: addWorkoutButtonPressed), for: .touchUpInside)
    }
    
    private func addWorkoutButtonPressed(_ action: UIAction) {
        
    }
    
}
