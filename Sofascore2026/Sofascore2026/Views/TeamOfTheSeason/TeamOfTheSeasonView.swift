import SwiftUI

struct TeamOfTheSeasonView: View {
    @StateObject private var viewModel = TeamOfTheSeasonViewModel()
    let onClose: () -> Void

    @State private var activeSlot: ActiveSlot?

    struct ActiveSlot: Identifiable {
        let line: PitchLine
        let index: Int
        var id: String { "\(line)-\(index)" }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    FormationChipsView(selected: viewModel.formation) {
                        viewModel.selectFormation($0)
                    }
                    counterRow
                    if let notice = viewModel.removalNotice {
                        noticeBanner(notice)
                    }
                    PitchView(viewModel: viewModel) { line, index in
                        activeSlot = ActiveSlot(line: line, index: index)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }
            submitBar
        }
        .background(Color(AppColors.surface))
        .sheet(item: $activeSlot) { slot in
            pickerSheet(for: slot)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingResult) {
            CommunityXIView(viewModel: viewModel, onBackToHome: {
                viewModel.dismissResult()
                DispatchQueue.main.async { onClose() }  
            })
        }
    }

    private var header: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(AppColors.onPrimary))
            }
            Spacer()
            VStack(spacing: 2) {
                Text(AppStrings.totsTitle)
                    .font(AppFonts.headlineSwiftUI)
                    .foregroundColor(Color(AppColors.onPrimary))
                Text(AppStrings.totsMockBadge)
                    .font(AppFonts.captionSwiftUI)
                    .foregroundColor(Color(AppColors.onPrimary).opacity(0.7))
            }
            Spacer()
            Image(systemName: "chevron.left")         
                .font(.system(size: 18, weight: .semibold))
                .opacity(0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(AppColors.primary))
    }

    private var counterRow: some View {
        HStack {
            Text(AppStrings.totsSelected(viewModel.selectedCount))
                .font(AppFonts.headlineSwiftUI)
                .foregroundColor(Color(AppColors.primaryText))
            Spacer()
            Button(action: viewModel.clearAll) {
                Text(AppStrings.totsClearAll)
                    .font(AppFonts.bodySwiftUI)
                    .foregroundColor(Color(AppColors.primary))
            }
        }
        .padding(.horizontal, 16)
    }

    private func noticeBanner(_ text: String) -> some View {
        Text(text)
            .font(AppFonts.captionSwiftUI)
            .foregroundColor(Color(AppColors.primaryText))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(AppColors.roundSectionBackground))
            .cornerRadius(8)
            .padding(.horizontal, 16)
    }

    private var submitBar: some View {
        Button(action: viewModel.submit) {
            Text(AppStrings.totsSubmit)
                .font(AppFonts.headlineSwiftUI)
                .foregroundColor(Color(AppColors.onPrimary))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(viewModel.isComplete ? Color(AppColors.primary)
                                                 : Color(AppColors.secondaryText))
        }
        .disabled(!viewModel.isComplete)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func pickerSheet(for slot: ActiveSlot) -> some View {
        let sheet = PlayerPickerSheet(
            line: slot.line,
            currentPlayer: viewModel.player(line: slot.line, slot: slot.index),
            candidates: viewModel.candidates(for: slot.line),
            isUsed: viewModel.isUsed,
            onSelect: { viewModel.pick($0, line: slot.line, slot: slot.index) },
            onRemove: { viewModel.removePick(line: slot.line, slot: slot.index) },
            onClose: { activeSlot = nil }
        )
        if #available(iOS 16.0, *) {
            sheet.presentationDetents([.medium, .large])
        } else {
            sheet
        }
    }
}
