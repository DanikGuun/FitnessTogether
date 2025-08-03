import Foundation

public protocol CalendarModel {
    func getItems(for interval: DateInterval, completion: @escaping ([WorkoutTimelineItem]) -> Void)
}

