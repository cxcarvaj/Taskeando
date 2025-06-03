//
//  TaskeandoApp.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 19/5/25.
//

import SwiftUI
import SMP25Kit
import UserNotifications

@main
struct TaskeandoApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.accessibilityReduceMotion) var motion
    @State private var vm = TaskeandoVM()
    @State private var nwMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .task {
                    do {
                        if try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                            print("Notificaciones aceptadas")
                        } else {
                            print("Ha dicho que no... uuuuuyyyy... qué mal rollito...")
                        }
                    } catch {
                        print("Error en los permisos de las notificaciones")
                    }
                }
                .onOpenURL { url in
                    print(url)
                    guard url.path == "/validateEmail",
                          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let token = components.queryItems?.first(where: { $0.name == "token" })?.value
                    else {
                        return
                    }
                    
                    Task {
                        await vm.validateUser(token: token)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                               .overlay {
                                   Rectangle()
                                       .fill(.ultraThinMaterial)
                                       .opacity(nwMonitor.status == .online ? 0 : 1)
                                       .ignoresSafeArea()
                               }
                               .overlay {
                                   WithoutNetworkView()
                                       .opacity(nwMonitor.status == .online ? 0 : 1)
                                       .offset(y: nwMonitor.status == .online ? motion ? 0 : 500 : 0)
                               }
                               .animation(.bouncy, value: nwMonitor.status)
        }
    }
}
