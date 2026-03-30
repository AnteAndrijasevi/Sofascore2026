import Foundation

enum Sport {
    case football
    case basketball
    case americanFootball

    var title: String {
        switch self {
        case .football: return AppStrings.football
        case .basketball: return AppStrings.basketball
        case .americanFootball: return AppStrings.americanFootball
        }
    }

    var iconName: String {
        switch self {
        case .football: return AppStrings.icFootball
        case .basketball: return AppStrings.icBasketball
        case .americanFootball: return AppStrings.icAmericanFootball
        }
    }
}
