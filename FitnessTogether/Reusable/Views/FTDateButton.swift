
import UIKit

public class FTDateButton: FTImageAndTitleButton {
     
    var date: Date {
        get {
            return _date
        }
        set {
            if let maxDate = maximumDate {
                _date = min(newValue, maxDate)
            }
            else {
                _date = newValue
            }
            updateLabel()
        }
    }
    private var _date = Date()
    
    var maximumDate: Date? = nil {
        didSet {
            if let maximumDate {
                date = min(date, maximumDate)
            }
        }
    }
    
    public override func setup() {
        super.setup()
        setupDefaultImageAndTitle()
    }
    
    private func setupDefaultImageAndTitle() {
        titleLabel.text = "дд.мм.гггг"
        imageView.image = UIImage(named: "calendar")
        addAction(UIAction(handler: dateButtonPressed), for: .touchUpInside)
    }
    
    private func dateButtonPressed(_ action: UIAction) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .date, startDate: date, maxDate: maximumDate, handler: dateSelected)
        let width = viewController?.view.bounds.width ?? 350
        viewController?.presentPopover(controller, size: CGSize(width: width, height: 250), sourceView: self, arrowDirections: [.down, .up])
    }
    
    private func dateSelected(_ action: UIAction) {
        guard let picker = action.sender as? UIDatePicker else { return }
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: picker.date)
        var currentDateComponents = Calendar.current.allComponents(from: date)
        currentDateComponents.day = components.day
        currentDateComponents.month = components.month
        currentDateComponents.year = components.year
        
        date = Calendar.current.date(from: currentDateComponents)!
        sendActions(for: .valueChanged)
    }
    
    private func updateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        titleLabel.text = formatter.string(from: date)
    }
    
}
