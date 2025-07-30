
import Foundation

public extension Calendar {
    static var actual: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.actual
        return calendar
    }
}
