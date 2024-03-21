import SwiftUI

struct ContentView: View {
    let height: CGFloat = 200

    @State var progress: CGFloat = 0.5
    @State var lastProgress: CGFloat = 0.5

    @State var scale = CGSize(width: 1.0, height: 1.0)
    @State var anchor: UnitPoint = .zero

    var body: some View {
        ZStack() {
            Color.blue

            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay() {
                    Rectangle()
                        .fill(Color.white)
                        .scaleEffect(CGSize(width: 1, height: progress), anchor: .bottom)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .frame(width: height/3, height: height)
                .scaleEffect(scale, anchor: anchor)
                .gesture(
                    simpleDrag
                )
        }
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea()
    }

    private var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                let offset = value.startLocation.y - value.location.y
                let diff = offset / height
                var progress = self.lastProgress + diff

                updateSliderScale(progress: progress)

                progress = max(0, progress)
                progress = min(1, progress)
                self.progress = progress
            }
            .onEnded { _ in
                lastProgress = progress
                withAnimation {
                    scale = CGSize(width: 1.0, height: 1.0)
                    anchor = .zero
                }
            }
        }

    private func updateSliderScale(progress: CGFloat) {
        let updateScale: (CGFloat) -> () = { progressOverRange in
            scale = CGSize(width: 1.0 - progressOverRange / 5, height: 1.0 + progressOverRange / 15)
        }

        if progress < 0 {
            let progressOverRange = abs(progress)
            anchor = .top
            updateScale(progressOverRange)
        }
        if progress > 1 {
            let progressOverRange = progress - 1
            anchor = .bottom
            updateScale(progressOverRange)
        }
    }
}

#Preview {
    ContentView()
}
