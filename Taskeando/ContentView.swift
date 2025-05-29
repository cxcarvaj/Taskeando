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
    @State private var showAddProject: Bool = false
    
    private let registration = NotificationCenter.default
        .publisher(for: .userValidated)

    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            VStack(spacing: 0) {
                if vm.projectsLogic.projects.count > 0 {
                    List {
                        ForEach(vm.projectsLogic.projects) { project in
                            ProjectRowView(project: project)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        Task { try await vm.getProjects() }
                    }
                } else {
                    ContentUnavailableView("Proyectos no disponibles",
                                       systemImage: "folder.badge.gearshape",
                                       description: Text("No hay proyectos en este momento. Crea nuevos proyectos tocando en +."))
                    .padding()
                }
            }
            .navigationTitle("TASKeando")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddProject = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Mi Perfil", systemImage: "person.circle") {
                            // Acción perfil
                        }
                        
                        Button("Configuración", systemImage: "gear") {
                            // Acción configuración
                        }
                        
                        Button("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right") {
                            withAnimation {
                                vm.logout()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddProject) {
                // Vista para añadir proyecto
                AddProjectView()
            }
        }
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
        .alert("Taskeando",
               isPresented: $vm.showAlert) {} message: {
            Text(vm.alertMessage)
        }
    }
}

// Vista de detalle (esqueleto)
struct ProjectDetailView: View {
    var project: Project
    
    var body: some View {
        Text("Detalle del proyecto: \(project.name)")
    }
}

#Preview {
    ContentView()
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
