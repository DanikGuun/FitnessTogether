
import Foundation

public extension Calendar {
    static var actual: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.actual
        return calendar
    }
    
    func allComponents(from date: Date) -> DateComponents {
        let components = self.dateComponents([.calendar, .year, .month, .day, .hour, .minute, .second], from: date)
        return components
    }
}
