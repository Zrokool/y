import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var lunchTime = Date()
    @State private var navigateToCountdown = false

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Lunch Time", selection: $lunchTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()

                Button(action: {
                    scheduleNotification()
                    navigateToCountdown = true
                }) {
                    Text("Set Lunch Reminder")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .background(
                    NavigationLink(destination: CountdownView(targetDate: lunchTime), isActive: $navigateToCountdown) {
                        EmptyView()
                    }.hidden()
                )
            }
            .onAppear {
                requestNotificationPermissions()
            }
        }
    }

    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notifications allowed")
            } else {
                print("Notifications denied")
            }
        }
    }

    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Lunch Reminder"
        content.body = "It's time to eat lunch!"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: lunchTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
