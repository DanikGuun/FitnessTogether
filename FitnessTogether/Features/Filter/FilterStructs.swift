
import Foundation
import FTDomainData

public struct FTFilterBag {
    public var dateInterval: FTFilterDateInterval
    public var workoutKind: FTWorkoutKind?
    
    public init(dateInterval: FTFilterDateInterval = .allTime,
                workoutKind: FTWorkoutKind? = nil) {
        self.dateInterval = dateInterval
        self.workoutKind = workoutKind
    }
    
    public func shouldInclude(_ workout: FTWorkout) -> Bool {
        let kindMatch = workoutKind == nil || workoutKind == workout.workoutKind //или фильтр на всё, или чтобы совпадало
        let dateMatch = self.dateInterval.dateInterval.contains(workout.startDate ?? Date())
        return dateMatch && kindMatch
    }
    
}

public enum FTFilterDateInterval: CaseIterable {
    public static var allCases: [FTFilterDateInterval] = [.week, .month, .threeMonths, .halfYear, .year, .allTime, .custom(DateInterval())]
    
    case week
    case toEndOfWeek
    case month
    case threeMonths
    case halfYear
    case year
    case allTime
    case custom(DateInterval)
    
    public var title: String {
        switch self {
        case .week:
            return "Неделя"
        case .toEndOfWeek:
            return "Текущая неделя"
        case .month:
            return "Месяц"
        case .threeMonths:
            return "3 месяца"
        case .halfYear:
            return "Полгода"
        case .year:
            return "Год"
        case .allTime:
            return "Все время"
        case .custom(_):
            return "Пользовательский"
        }
    }
    
    public var dateInterval: DateInterval {
        let calendar = Calendar.current
        
        if case .custom(let interval) = self  {
            return interval
        }
        else if case .toEndOfWeek = self {
            var weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date())!
            weekInterval.start = Date().addingTimeInterval(-2 * 3600)
            return weekInterval
        }

        let endDate = Date()
        
        let startDate: Date = {
            switch self {
            case .week:
                return calendar.date(byAdding: .weekOfYear, value: -1, to: endDate) ?? endDate
            case .month:
                return calendar.date(byAdding: .month, value: -1, to: endDate) ?? endDate
            case .threeMonths:
                return calendar.date(byAdding: .month, value: -3, to: endDate) ?? endDate
            case .halfYear:
                return calendar.date(byAdding: .month, value: -6, to: endDate) ?? endDate
            case .year:
                return calendar.date(byAdding: .year, value: -1, to: endDate) ?? endDate
            case .allTime:
                return Date(timeIntervalSince1970: 0)
            default:
                return Date()
            }
        }()
        
        return DateInterval(start: startDate, end: endDate)
    }

}
