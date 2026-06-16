import SwiftUI

struct PitchView: View {
    @ObservedObject var viewModel: TeamOfTheSeasonViewModel
    var readOnly: Bool = false
    var onSlotTap: ((PitchLine, Int) -> Void)? = nil

    var body: some View {
        ZStack {
            Color(hex: "#1E7B41")
            stripes
            PitchMarkings().stroke(Color.white.opacity(0.7), lineWidth: 1.5)
            lines
        }
        .aspectRatio(0.66, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var stripes: some View {
        VStack(spacing: 0) {
            ForEach(0..<6) { index in
                (index.isMultiple(of: 2) ? Color.white.opacity(0.04) : Color.clear)
                    .frame(maxHeight: .infinity)
            }
        }
    }

    private var lines: some View {
        VStack(spacing: 0) {
            ForEach(PitchLine.layoutOrder, id: \.self) { line in
                lineRow(line).frame(maxHeight: .infinity)
            }
        }
        .padding(.vertical, 12)
    }

    private func lineRow(_ line: PitchLine) -> some View {
        HStack(spacing: 0) {
            ForEach(viewModel.slotItems(for: line)) { slot in
                PlayerSlotView(player: slot.player) {
                    guard !readOnly else { return }
                    onSlotTap?(line, slot.id)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
    }
}

// MARK: - PitchMarkings
private struct PitchMarkings: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        path.addRect(rect.insetBy(dx: 1, dy: 1))

        path.move(to: CGPoint(x: 0, y: h / 2))
        path.addLine(to: CGPoint(x: w, y: h / 2))

        let centerR = w * 0.13
        path.addEllipse(in: CGRect(x: w / 2 - centerR, y: h / 2 - centerR,
                                   width: centerR * 2, height: centerR * 2))

        let penW = w * 0.52, penH = h * 0.13
        let sixW = w * 0.26, sixH = h * 0.05
        path.addRect(CGRect(x: (w - penW) / 2, y: 0, width: penW, height: penH))
        path.addRect(CGRect(x: (w - sixW) / 2, y: 0, width: sixW, height: sixH))
        path.addRect(CGRect(x: (w - penW) / 2, y: h - penH, width: penW, height: penH))
        path.addRect(CGRect(x: (w - sixW) / 2, y: h - sixH, width: sixW, height: sixH))

        let dHalf = w * 0.11
        let dDepth = h * 0.04
        path.move(to: CGPoint(x: w / 2 - dHalf, y: penH))
        path.addQuadCurve(to: CGPoint(x: w / 2 + dHalf, y: penH),
                          control: CGPoint(x: w / 2, y: penH + dDepth))
        path.move(to: CGPoint(x: w / 2 - dHalf, y: h - penH))
        path.addQuadCurve(to: CGPoint(x: w / 2 + dHalf, y: h - penH),
                          control: CGPoint(x: w / 2, y: h - penH - dDepth))

        return path
    }
}
