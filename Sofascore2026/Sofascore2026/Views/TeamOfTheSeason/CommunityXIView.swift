import SwiftUI

struct CommunityXIView: View {
    @ObservedObject var viewModel: TeamOfTheSeasonViewModel
    let onBackToHome: () -> Void

    @State private var isSharing = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    hero
                    PitchView(viewModel: viewModel, readOnly: true)
                        .padding(.horizontal, 16)
                    backButton
                }
                .padding(.vertical, 16)
            }
        }
        .background(Color(AppColors.surface))
        .sheet(isPresented: $isSharing) {
            ShareSheet(items: [viewModel.shareText])
        }
    }

    private var header: some View {
        ZStack {
            Text(AppStrings.totsCommunityXI)
                .font(AppFonts.headlineSwiftUI)
                .foregroundColor(Color(AppColors.onPrimary))
            HStack {
                Spacer()
                Button { isSharing = true } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(AppColors.onPrimary))
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(AppColors.primary))
    }

    private var hero: some View {
        VStack(spacing: 8) {
            Image(systemName: AppStrings.totsTrophySymbol)
                .font(.system(size: 44))
                .foregroundColor(Color(AppColors.primary))
            Text(AppStrings.totsCommunityXI)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(AppColors.primaryText))
            Text(viewModel.formation.title)
                .font(AppFonts.bodySwiftUI)
                .foregroundColor(Color(AppColors.secondaryText))
            HStack(spacing: 12) {
                Text(AppStrings.totsVotesLine)
                Text("·")
                Text(AppStrings.totsDaysLeft)
            }
            .font(AppFonts.captionSwiftUI)
            .foregroundColor(Color(AppColors.secondaryText))
            Text(AppStrings.totsMockBadge)
                .font(AppFonts.captionSwiftUI)
                .foregroundColor(Color(AppColors.liveRed))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(AppColors.roundSectionBackground))
    }

    private var backButton: some View {
        Button(action: onBackToHome) {
            Text(AppStrings.totsBackToHome)
                .font(AppFonts.headlineSwiftUI)
                .foregroundColor(Color(AppColors.onPrimary))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(AppColors.primary))
        }
        .padding(.horizontal, 16)
    }
}
