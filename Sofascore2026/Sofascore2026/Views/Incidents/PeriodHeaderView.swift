import SwiftUI

struct PeriodHeaderView: View {
    let title: String
    let isLive: Bool

    private var textColor: Color {
        isLive ? Color(AppColors.liveRed) : Color(AppColors.primaryText)
    }

    var body: some View {
        Text(title)
            .font(AppFonts.sectionHeaderSwiftUI)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                .fill(Color(AppColors.roundSectionBackground))
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}
