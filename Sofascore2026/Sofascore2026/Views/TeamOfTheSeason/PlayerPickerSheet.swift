import SwiftUI

struct PlayerPickerSheet: View {
    let line: PitchLine
    let currentPlayer: TotsPlayer?
    let candidates: [TotsPlayer]
    let isUsed: (TotsPlayer) -> Bool
    let onSelect: (TotsPlayer) -> Void
    let onRemove: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(candidates) { player in
                        row(for: player)
                    }
                }
            }
        }
        .background(Color(AppColors.surface))
    }

    private var header: some View {
        HStack {
            Text(line.title)
                .font(AppFonts.headlineSwiftUI)
                .foregroundColor(Color(AppColors.primaryText))
            Spacer()
            if currentPlayer != nil {
                Button {
                    onRemove()
                    onClose()
                } label: {
                    Text(AppStrings.totsRemove)
                        .font(AppFonts.bodySwiftUI)
                        .foregroundColor(Color(AppColors.liveRed))
                }
            }
        }
        .padding(16)
    }

    private func row(for player: TotsPlayer) -> some View {
        let isCurrent = player == currentPlayer
        let disabled = isUsed(player) && !isCurrent
        return Button {
            onSelect(player)
            onClose()
        } label: {
            HStack(spacing: 12) {
                JerseyView(player: player).frame(width: 28, height: 28)
                Text(player.name)
                    .font(AppFonts.bodySwiftUI)
                    .foregroundColor(Color(AppColors.primaryText))
                Spacer()
                Text("\(player.number)")
                    .font(AppFonts.captionSwiftUI)
                    .foregroundColor(Color(AppColors.secondaryText))
                if isCurrent {
                    Image(systemName: "checkmark").foregroundColor(Color(AppColors.primary))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .opacity(disabled ? 0.4 : 1)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}
