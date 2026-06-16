import SwiftUI

struct PlayerSlotView: View {
    let player: TotsPlayer?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                if let player {
                    JerseyView(player: player)
                        .frame(width: 40, height: 40)
                    Text(player.name)
                        .font(AppFonts.captionSwiftUI)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                } else {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.85),
                                      style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .frame(width: 40, height: 40)
                }
            }
            .frame(width: 66)
        }
        .buttonStyle(.plain)
    }
}
