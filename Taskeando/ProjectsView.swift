//
//  ProjectsView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(TaskeandoVM.self) var vm
    @State private var showAddProject: Bool = false

    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            VStack(spacing: 0) {
                if vm.projectsLogic.projects.count > 0 {
                    List {
                        ForEach($vm.projectsLogic.projects) { $project in
                            ProjectRowView(project: $project)
                        }
                    }
                    .listStyle(.plain)
//                    .buttonStyle(.plain) //Esto si usamos GroupedBox
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
    }
}

#Preview {
    ProjectsView()
        .environment(TaskeandoVM(networkRepository: RepositoryTest()))
}
