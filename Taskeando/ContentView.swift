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

    var body: some View {
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
                        // Añadir lógica para recargar proyectos
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
                                vm.isUserLogged = false
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
                Text("Nueva vista para crear proyecto")
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .backgroundOverlay(vm.isUserLogged)
        .overlay {
            LoginView {
                withAnimation(.spring(duration: 0.7, bounce: 0.4)) {
                    vm.isUserLogged = true
                }
            }
            .opacity(vm.isUserLogged ? 0 : 1)
            .offset(y: vm.isUserLogged ? reduceMotion ? 0 : 500 : 0)
        }
        .animation(.spring(duration: 0.5, bounce: 0.3), value: vm.isUserLogged)
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
