import SwiftUI

struct SunriseGlassPillToggleStyle: ToggleStyle {
    var onColors: [Color] = [
        Color(hex: "FFB169"),
        Color(hex: "FF7506")
    ]
    var offColors: [Color] = [
        Color(hex: "E8EBF0"),
        Color(hex: "D6DAE0")
    ]
    var trackWidth: CGFloat = 64
    var trackHeight: CGFloat = 32
    var knobSize: CGFloat = 28

    @Environment(\.colorScheme) private var scheme

    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        Button {
            print("[SunriseToggle] Button tapped, current state: \(isOn)")
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                configuration.isOn.toggle()
                print("[SunriseToggle] After toggle: \(configuration.isOn)")
                #if os(iOS)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
            }
        } label: {
            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: isOn ? onColors : offColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.black.opacity(isOn ? 0.08 : 0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(isOn ? 0.2 : 0.08), radius: isOn ? 6 : 3, x: 0, y: isOn ? 3 : 2)

                Text(isOn ? "ON" : "OFF")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(0.8)
                    .foregroundColor(isOn ? Color.white.opacity(0.9) : Color.black.opacity(0.55))
                    .allowsHitTesting(false)

                HStack {
                    if isOn { Spacer(minLength: 0) }
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: knobGradient(for: isOn)),
                                center: .center,
                                startRadius: 2,
                                endRadius: knobSize / 2
                            )
                        )
                        .overlay(
                            Circle().stroke(Color.black.opacity(0.08), lineWidth: 0.7)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 2.5, x: 0, y: 1)
                        .frame(width: knobSize - 4, height: knobSize - 4)
                    if !isOn { Spacer(minLength: 0) }
                }
                .padding(.horizontal, 4)
                .frame(width: trackWidth, height: trackHeight)
                .animation(.spring(response: 0.28, dampingFraction: 0.82), value: isOn)
            }
            .frame(width: trackWidth, height: trackHeight)
            .accessibilityElement(children: .ignore)
            .accessibilityValue(Text(isOn ? "On" : "Off"))
        }
        .buttonStyle(.plain)
    }

    private func knobGradient(for isOn: Bool) -> [Color] {
        if isOn {
            return [Color.white, Color(hex: "FFE6CF")]
        } else {
            return [Color.white, Color(hex: "DEE3EA")]
        }
    }
}
