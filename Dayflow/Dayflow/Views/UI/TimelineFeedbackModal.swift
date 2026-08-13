//
//  TimelineFeedbackModal.swift
//  Dayflow
//
//  Feedback card shown after rating a timeline summary.
//

import SwiftUI

enum TimelineFeedbackMode {
  case form
  case thanks
}

struct TimelineFeedbackModal: View {
  @Binding var message: String
  @Binding var shareLogs: Bool
  let direction: TimelineRatingDirection
  let mode: TimelineFeedbackMode
  let onSubmit: () -> Void
  let onClose: () -> Void

  @FocusState private var isEditorFocused: Bool
  @Environment(\.dayflowTheme) private var theme

  private let placeholder =
    "I don’t have access to your timeline (privacy first!), so your feedback here helps improve the quality of Dayflow for everyone."

  var body: some View {
    ZStack(alignment: .topTrailing) {
      modalCard

      Button(action: onClose) {
        Image(systemName: "xmark")
          .font(.system(size: 12.5, weight: .semibold))
          .foregroundColor(theme.isDark ? Color(hex: "C9CBD6") : Color(hex: "FF8046").opacity(0.7))
          .frame(width: 22, height: 22)
          .background(theme.isDark ? Color.clear : Color.white.opacity(0.9))
          .clipShape(Circle())
      }
      .buttonStyle(.plain)
      .pointingHandCursor()
      .offset(x: -8, y: 6)
    }
    .accessibilityElement(children: .contain)
    .accessibilityLabel("Timeline feedback form")
    .accessibilityHint("Share more context after rating this summary.")
  }

  @ViewBuilder
  private var modalCard: some View {
    VStack(spacing: mode == .form ? 20 : 24) {
      switch mode {
      case .form:
        formContent
      case .thanks:
        thanksContent
      }
    }
    .padding(24)
    .frame(width: 286)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(cardFill)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(theme.isDark ? Color(hex: "585858") : Color(hex: "ECECEC"), lineWidth: 1)
    )
    .shadow(
      color: Color.black.opacity(theme.isDark ? 0.35 : 0.07), radius: 12, x: 0, y: 6)
  }

  private var cardFill: AnyShapeStyle {
    if theme.isDark {
      return AnyShapeStyle(
        LinearGradient(
          gradient: Gradient(stops: [
            .init(color: Color(hex: "272F43"), location: 0),
            .init(color: Color(hex: "272F43"), location: 0.3),
            .init(color: Color(hex: "3F3D52"), location: 0.85),
          ]),
          startPoint: .bottom,
          endPoint: .top
        )
      )
    }
    return AnyShapeStyle(
      LinearGradient(
        gradient: Gradient(stops: [
          .init(color: Color(hex: "FFF4E9"), location: 0),
          .init(color: Color.white, location: 0.85),
        ]),
        startPoint: .bottom,
        endPoint: .top
      )
    )
  }

  private var primaryText: Color {
    theme.isDark ? .white : Color(hex: "333333")
  }

  private var formContent: some View {
    VStack(spacing: 16) {
      VStack(spacing: 12) {
        Text("Thank you!")
          .font(Font.custom("InstrumentSerif-Regular", size: 18))
          .foregroundColor(primaryText)
          .multilineTextAlignment(.center)

        Text("Tell us more about your feedback")
          .font(Font.custom("Nunito", size: 13).weight(.medium))
          .foregroundColor(Color(hex: "333333"))
          .multilineTextAlignment(.center)
      }

      VStack(spacing: 8) {
        ZStack(alignment: .topLeading) {
          TextEditor(text: $message)
            .font(Font.custom("Nunito", size: 12).weight(.medium))
            .foregroundColor(Color(hex: "333333"))
            .padding(.horizontal, 6)
            .padding(.vertical, 8)
            .background(theme.isDark ? Color.white.opacity(0.06) : Color.white)
            .frame(height: 90)
            .cornerRadius(4)
            .overlay(
              RoundedRectangle(cornerRadius: 4)
                .stroke(theme.isDark ? Color(hex: "5C5F70") : Color(hex: "D9D9D9"), lineWidth: 1)
            )
            .background(ThinScrollerInstaller())
            .focused($isEditorFocused)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isEditorFocused = true
              }
            }
            .scrollContentBackground(.hidden)

          if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text(placeholder)
              .font(Font.custom("Nunito", size: 12).weight(.medium))
              .foregroundColor(Color(hex: "AAAAAA"))
              .padding(.horizontal, 12)
              .padding(.vertical, 12)
          }
        }

        Button {
          shareLogs.toggle()
        } label: {
          HStack(alignment: .top, spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
              .stroke(Color(hex: "AAAAAA"), lineWidth: shareLogs ? 0 : 1)
              .frame(width: 14, height: 14)
              .overlay(
                Image(systemName: "checkmark")
                  .font(.system(size: 8, weight: .bold))
                  .foregroundColor(.white)
                  .opacity(shareLogs ? 1 : 0)
              )
              .background(
                RoundedRectangle(cornerRadius: 2)
                  .fill(
                    shareLogs
                      ? (theme.isDark ? Color(hex: "D1653E") : Color(hex: "FF8046"))
                      : Color.clear)
              )

            Text("I’d like to share this log to the developer to help improve the product.")
              .font(Font.custom("Nunito", size: 10).weight(.medium))
              .foregroundColor(Color.black)
              .fixedSize(horizontal: false, vertical: true)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingHandCursor()
      }

      Button(action: onSubmit) {
        Text("Submit")
          .font(Font.custom("Nunito", size: 12).weight(.medium))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .frame(height: 32)
          .background(theme.primaryButtonFill)
          .overlay(InnerGlow(shape: Capsule(), color: theme.primaryButtonInnerGlow, radius: 3))
          .overlay(Capsule().strokeBorder(theme.primaryButtonBorder, lineWidth: 1))
          .clipShape(Capsule())
      }
      .buttonStyle(.plain)
      .pointingHandCursor()
    }
  }

  private var thanksContent: some View {
    VStack(spacing: 20) {
      Text("Thank you for your feedback!")
        .font(Font.custom("InstrumentSerif-Regular", size: 18))
        .foregroundColor(primaryText)
        .multilineTextAlignment(.center)
        .padding(.bottom, 4)

      VStack(alignment: .leading, spacing: 12) {
        Text(
          "If you find that your activities are summarized inaccurately, try editing the descriptions of your categories to improve Dayflow’s accuracy."
        )
        .font(Font.custom("Nunito", size: 12).weight(.medium))
        .foregroundColor(Color(hex: "333333"))
        .multilineTextAlignment(.leading)

        categoryTipsIllustration
      }
    }
  }
}

extension TimelineFeedbackModal {
  private var categoryTipsIllustration: some View {
    Image("CategoryEditUI")
      .resizable()
      .scaledToFit()
      .frame(maxWidth: .infinity)
      .frame(height: 140)
      .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.white.opacity(0.7), lineWidth: 0.5)
      )
      .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
      .accessibilityLabel("Illustration showing how to edit categories")
  }
}

#Preview {
  TimelineFeedbackModal(
    message: .constant(""),
    shareLogs: .constant(true),
    direction: .up,
    mode: .form,
    onSubmit: {},
    onClose: {}
  )
  .padding()
  .background(Color.gray.opacity(0.1))

  TimelineFeedbackModal(
    message: .constant(""),
    shareLogs: .constant(true),
    direction: .up,
    mode: .thanks,
    onSubmit: {},
    onClose: {}
  )
  .padding()
  .background(Color.gray.opacity(0.1))
}
