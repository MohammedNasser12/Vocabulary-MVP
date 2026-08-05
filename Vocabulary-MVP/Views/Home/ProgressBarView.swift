import SwiftUI

/// Segmented progress bar showing daily word completion progress.
///
/// Features the "Word Mastery Pulse" UX enhancement:
/// - Individual segments glow when a new word is viewed
/// - A shimmer sweeps across the bar when all words are completed
struct ProgressBarView: View {

    let current: Int
    let total: Int
    let pulsingSegment: Int?
    let allComplete: Bool

    @State private var shimmerOffset: CGFloat = -1.0

    var body: some View {
        HStack(spacing: 8) {
            // Bookmark icon with count
            HStack(spacing: 4) {
                Image(systemName: "bookmark")
                    .font(.system(size: 14))
                Text("\(current)/\(total)")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.9))

            // Segmented progress bar
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let segmentWidth = (totalWidth - CGFloat(total - 1) * 3) / CGFloat(total)

                HStack(spacing: 3) {
                    ForEach(0..<total, id: \.self) { index in
                        segmentView(
                            index: index,
                            width: segmentWidth
                        )
                    }
                }
                .overlay {
                    // Shimmer overlay when all complete
                    if allComplete {
                        shimmerOverlay(width: totalWidth)
                    }
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
        )
        .onChange(of: allComplete) { _, isComplete in
            if isComplete {
                startShimmer()
            }
        }
    }

    // MARK: - Segment

    @ViewBuilder
    private func segmentView(index: Int, width: CGFloat) -> some View {
        let isFilled = index < current
        let isPulsing = pulsingSegment == index

        RoundedRectangle(cornerRadius: 3)
            .fill(isFilled ? Color.white : Color.white.opacity(0.3))
            .frame(width: width)
            .overlay {
                if isPulsing {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.appTeal)
                        .shadow(color: Color.appTeal.opacity(0.8), radius: 6, x: 0, y: 0)
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.6), value: isPulsing)
                }
            }
            .animation(Constants.smoothTransition, value: isFilled)
    }

    // MARK: - Shimmer

    private func shimmerOverlay(width: CGFloat) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .clear,
                        Color.white.opacity(0.5),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 60)
            .offset(x: shimmerOffset * width)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private func startShimmer() {
        shimmerOffset = -0.5
        withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
            shimmerOffset = 1.5
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(red: 0.3, green: 0.4, blue: 0.35), Color(red: 0.15, green: 0.2, blue: 0.18)],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()

        VStack(spacing: 30) {
            ProgressBarView(current: 0, total: 5, pulsingSegment: nil, allComplete: false)
            ProgressBarView(current: 3, total: 5, pulsingSegment: 2, allComplete: false)
            ProgressBarView(current: 5, total: 5, pulsingSegment: nil, allComplete: true)
        }
        .padding(.horizontal, 40)
    }
}
