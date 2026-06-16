import Foundation

@MainActor
enum DateFormattersHelper {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static func formattedDate(from timestamp: Int) -> String {
        dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }

    static func formattedTime(from timestamp: Int) -> String {
        timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
