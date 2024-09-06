import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationTimeInterval") private var notificationTimeInterval = Date().timeIntervalSince1970
    
    @State private var showingTimePicker = false
    @State private var tempNotificationTime: Date = Date()
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var notificationTime: Date {
        get { Date(timeIntervalSince1970: notificationTimeInterval) }
        set { notificationTimeInterval = newValue.timeIntervalSince1970 }
    }
    
    var body: some View {
        NavigationView {
            Form {
                notificationSection
                appInfoSection
                contactSection
            }
            .navigationTitle("設定")
            .sheet(isPresented: $showingTimePicker) {
                TimePickerView(selectedTime: $tempNotificationTime, isPresented: $showingTimePicker, onDismiss: updateNotificationTime)
            }
        }
        .accentColor(themeManager.currentTheme.accent)
    }
    
    private var notificationSection: some View {
        Section(header: Text("通知設定")) {
            Toggle("通知を有効にする", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, newValue in
                    if newValue {
                        requestNotificationPermission()
                    } else {
                        cancelAllNotifications()
                    }
                }
            
            if notificationsEnabled {
                HStack {
                    Text("通知時間")
                    Spacer()
                    Text(notificationTime, style: .time)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            tempNotificationTime = notificationTime
                            showingTimePicker = true
                        }
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        Section(header: Text("アプリ情報")) {
            HStack {
                Text("バージョン")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "不明")
            }
        }
    }
    
    private var contactSection: some View {
        Section {
            Button("お問い合わせ") {
                // お問い合わせ機能を実装
            }
            
            Button("プライバシーポリシー") {
                // プライバシーポリシーを表示
            }
        }
    }
    
    private func updateNotificationTime() {
        notificationTimeInterval = tempNotificationTime.timeIntervalSince1970
        scheduleNotification()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    print("通知が許可されました")
                    scheduleNotification()
                } else {
                    print("通知が拒否されました")
                    notificationsEnabled = false
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "デイリーカレンダー"
        content.body = "今日の予定を確認しましょう！"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

struct TimePickerView: View {
    @Binding var selectedTime: Date
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            DatePicker("通知時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .navigationTitle("通知時間を選択")
                .navigationBarItems(trailing: Button("完了") {
                    onDismiss()
                    isPresented = false
                })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
