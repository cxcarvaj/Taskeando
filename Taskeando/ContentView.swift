//
//  ContentView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 19/5/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(TaskeandoVM.self) var vm
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion: Bool
    
    @State private var selectedTab: Int = 0
    
    private let registration = NotificationCenter.default
        .publisher(for: .userValidated)
        .receive(on: DispatchQueue.main)
    
    private let viewTask = NotificationCenter.default
        .publisher(for: .viewTask)
        .receive(on: DispatchQueue.main)
    
    @State private var projectTask: ProjectWithTask?
    
    var body: some View {
        @Bindable var vm = vm
        
        ProjectsView()
            .backgroundOverlay(vm.isUserLogged)
            .overlay {
                LoginView()
                    .opacity(vm.isUserLogged ? 0 : 1)
                    .offset(y: vm.isUserLogged ? reduceMotion ? 0 : 500 : 0)
            }
            .overlay {
                if vm.isLoadingProjects {
                    Color.black.opacity(0.18).ignoresSafeArea()
                    ProgressView("Actualizando proyectos...")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .accessibilityLabel("Actualizando proyectos")
                }
            }
            .animation(.spring(duration: 0.5, bounce: 0.3), value: vm.isUserLogged)
            .onReceive(registration) { _ in
                vm.alertMessage = "User validated. You can now login to your account."
                vm.showAlert.toggle()
            }
            .onReceive(viewTask) { notification in
                print("Recibo la notificación")
                Task { @MainActor in
                    print("Estoy dentro del task")
                    if let pt = vm.getProjectTask(notification: notification) {
                        print("He recuperado los valores")
                        projectTask = ProjectWithTask(project: pt.project, task: pt.task)
                    } else {
                        projectTask = nil
                    }
                }
            }
            .sheet(item: $projectTask) { projectTask in
                TaskDetailView(task: projectTask.task)
            }
            .alert("Taskeando",
                   isPresented: $vm.showAlert) {} message: {
                Text(vm.alertMessage)
            }
    }
}

#Preview {
    ContentView()
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
