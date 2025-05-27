//
//  TaskeandoApp.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 19/5/25.
//

import SwiftUI

@main
struct TaskeandoApp: App {
    @State private var vm = TaskeandoVM()

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
        }
    }
}
