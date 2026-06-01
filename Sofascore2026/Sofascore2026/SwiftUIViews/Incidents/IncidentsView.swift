import SwiftUI

struct IncidentsView: View {
    @StateObject private var viewModel: IncidentsViewModel
    private let sport: Sport

    init(eventId: Int, sport: Sport) {
        self.sport = sport
        _viewModel = StateObject(wrappedValue: IncidentsViewModel(eventId: eventId, sport: sport))
    }

    var body: some View {
        ScrollView {
            content
        }
        .onAppear {
            viewModel.load()
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
                ForEach(Array(sections.reversed())) { section in
                    PeriodHeaderView(title: section.header)
                    ForEach(section.incidents.reversed()) { displayable in
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
            Text("No incidents yet.")
                .font(.system(size: 14))
                .foregroundColor(Color(AppColors.secondaryText))
                .frame(maxWidth: .infinity, minHeight: 80)

        case .error:
            Text("Could not load incidents.")
                .font(.system(size: 14))
                .foregroundColor(Color(AppColors.liveRed))
                .frame(maxWidth: .infinity, minHeight: 80)
        }
    }
}
