import SwiftUI

/// Name input screen — "What do you want to be called?"
///
/// Features a text field for the user's name with Skip option.
/// The name is optional; users can proceed with or without entering one.
struct NameInputView: View {

    @Bindable var viewModel: OnboardingViewModel

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Skip button
            HStack {
                Spacer()
                SkipButton { viewModel.skip() }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, 8)

            Spacer()
                .frame(height: 24)

            // Title
            Text("What do you want to\nbe called?")
                .font(.appTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appText)
                .padding(.horizontal, Constants.horizontalPadding)

            Spacer()
                .frame(height: 32)

            // Text field
            TextField("Your name", text: $viewModel.name)
                .font(.appBody)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                        .stroke(Color.appBorderLight, lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.optionCornerRadius)
                                .fill(Color.appOptionBackground)
                        )
                )
                .padding(.horizontal, Constants.horizontalPadding)
                .focused($isTextFieldFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.continue)
                .onSubmit {
                    viewModel.advance()
                }

            Spacer()

            // CTA
            PrimaryButton(title: "Continue") {
                isTextFieldFocused = false
                viewModel.advance()
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        NameInputView(viewModel: OnboardingViewModel())
    }
}
