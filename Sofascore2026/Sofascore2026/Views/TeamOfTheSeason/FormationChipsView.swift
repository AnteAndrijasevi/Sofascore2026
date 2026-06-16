import SwiftUI

struct FormationChipsView: View {
    let selected: Formation
    let onSelect: (Formation) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Formation.allCases) { formation in
                    let isSelected = formation == selected
                    Button { onSelect(formation) } label: {
                        Text(formation.title)
                            .font(AppFonts.headlineSwiftUI)
                            .foregroundColor(isSelected ? Color(AppColors.onPrimary)
                                                         : Color(AppColors.primaryText))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(isSelected ? Color(AppColors.primary)
                                                          : Color(AppColors.roundSectionBackground))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
