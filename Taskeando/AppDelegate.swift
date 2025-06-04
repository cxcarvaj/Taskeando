//
//  AppDelegate.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 2/6/25.
//


import SwiftUI
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationsDelegate = NotificationsDelegate()
    let networkRepository = Repository()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationsDelegate
        print("HOLA")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Task {
            do {
                let tokenBytes = deviceToken.map { byte in
                    String(format: "%02.2hhx", byte)
                }
                try await networkRepository.sendAPNSToken(token: tokenBytes.joined())
            } catch {
                print("Error enviando el token al server")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print(error)
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
    // Esto es para gestionar las notificaciones cuando mi usuario tenga la app abierta, por eso debo generar la tabla DeviceUserTokens.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
            .banner
    }
}
