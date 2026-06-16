import SwiftUI

struct IncidentsView: View {
    @StateObject private var viewModel: IncidentsViewModel
    private let sport: Sport
    private let isLive: Bool

    init(eventId: Int, sport: Sport, isLive: Bool) {
        self.sport = sport
        self.isLive = isLive
        _viewModel = StateObject(wrappedValue: IncidentsViewModel(eventId: eventId, sport: sport))
    }

    var body: some View {
        ScrollView {
            content
        }
        .onAppear {
                    viewModel.loadIfNeeded()
                }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 120)

        case .loaded(let sections):
            LazyVStack(spacing: 0) {
                ForEach(sections) { section in
                                    PeriodHeaderView(title: section.header, isLive: isLive)
                                    ForEach(section.incidents) { displayable in
                        IncidentRowView(
                            incident: displayable.incident,
                            displayScore: displayable.displayScore,
                            sport: sport
                        )
                    }
                }
            }
            .padding(.vertical, 8)

        case .empty:
            Text(AppStrings.noIncidents)
                .font(AppFonts.bodySwiftUI)
                .foregroundColor(Color(AppColors.secondaryText))
                .frame(maxWidth: .infinity, minHeight: 80)

        case .error:
            Text(AppStrings.incidentsLoadError)
                .font(AppFonts.bodySwiftUI)
                .foregroundColor(Color(AppColors.liveRed))
                .frame(maxWidth: .infinity, minHeight: 80)
        }
    }
}
