import SwiftUI

struct PeriodHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color(AppColors.liveRed))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.94, green: 0.95, blue: 0.97))
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}

#Preview {
    PeriodHeaderView(title: "FT (1 - 2)")
}
