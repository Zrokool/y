import SwiftUI

struct CountdownView: View {
    let targetDate: Date
    @State private var remainingTime: String = ""

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Lunch Reminder Set!")
                .font(.headline)
                .foregroundColor(.white)
            Text("Time remaining:")
                .font(.subheadline)
                .foregroundColor(.white)
            Text(remainingTime)
                .font(.largeTitle)
                .foregroundColor(.white)
                .onReceive(timer) { _ in
                    updateRemainingTime()
                }
        }
        .padding()
        .background(Color.green)
        .onAppear {
            updateRemainingTime()
        }
    }

    func updateRemainingTime() {
        let now = Date()
        let remainingSeconds = Int(targetDate.timeIntervalSince(now))
        if remainingSeconds > 0 {
            let hours = remainingSeconds / 3600
            let minutes = (remainingSeconds % 3600) / 60
            let seconds = remainingSeconds % 60
            remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            remainingTime = "00:00:00"
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(targetDate: Date().addingTimeInterval(3600)) // 1 hour from now
    }
}
