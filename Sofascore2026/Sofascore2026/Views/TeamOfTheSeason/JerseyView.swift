import SwiftUI

struct JerseyView: View {
    let player: TotsPlayer

    var body: some View {
        ZStack {
            JerseyShape().fill(Color(hex: player.club.shirtHex))
            JerseyShape().stroke(Color.black.opacity(0.12), lineWidth: 1)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - JerseyShape
private struct JerseyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()
        path.move(to: CGPoint(x: 0.30 * w, y: 0))
        path.addLine(to: CGPoint(x: 0.0,  y: 0.18 * h))
        path.addLine(to: CGPoint(x: 0.12 * w, y: 0.42 * h))
        path.addLine(to: CGPoint(x: 0.27 * w, y: 0.30 * h))
        path.addLine(to: CGPoint(x: 0.22 * w, y: h))
        path.addLine(to: CGPoint(x: 0.78 * w, y: h))
        path.addLine(to: CGPoint(x: 0.73 * w, y: 0.30 * h))
        path.addLine(to: CGPoint(x: 0.88 * w, y: 0.42 * h))
        path.addLine(to: CGPoint(x: w,    y: 0.18 * h))
        path.addLine(to: CGPoint(x: 0.70 * w, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0.30 * w, y: 0),
                          control: CGPoint(x: 0.50 * w, y: 0.13 * h))
        path.closeSubpath()
        return path
    }
}
