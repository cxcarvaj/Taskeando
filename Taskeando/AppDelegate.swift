import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationsDelegate = NotificationsDelegate()Add commentMore actions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationsDelegate
        print("HOLA")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}

final class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let projectID = userInfo["projectID"] as? String,
           let taskID = userInfo["taskID"] as? String,
           let idProject = UUID(uuidString: projectID),
           let idTask = UUID(uuidString: taskID) {
            print("Proceso los datos")
            print("Mando los datos")
            NotificationCenter.default.post(name: .viewTask, object: nil, userInfo: ["projectID": idProject, "taskID" : idTask])
        }
        completionHandler()
    }
}