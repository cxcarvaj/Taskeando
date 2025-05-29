//
//  TaskeandoApp.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 19/5/25.
//

import SwiftUI
import SMP25Kit

@main
struct TaskeandoApp: App {
    @Environment(\.accessibilityReduceMotion) var motion
    @State private var vm = TaskeandoVM()
    @State private var nwMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
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
