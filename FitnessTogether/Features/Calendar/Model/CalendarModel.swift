
public protocol CalendarModel {
    func getItems(completion: @escaping ([WorkoutTimelineItem]) -> Void)
}

