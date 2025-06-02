//
//  ProjectDetailView.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import SwiftUI

struct ProjectDetailView: View {
    @Environment(TaskeandoVM.self) var vm
    @State private var detailVM = ProjectDetailVM()
    @State private var addTask = false
    
    @Binding var project: Project
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProjectHeaderView(project: project, detailVM: $detailVM)
                
                TaskSectionView(
                    tasks: project.tasks,
                    onAdd: { addTask = true }
                )
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .sheet(isPresented: $addTask) {
            AddTaskView(project: project)
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            detailVM.setTaskState(project.state)
            detailVM.setProjectType(project.type)
        }
    }
}

#Preview {
    @Previewable @State var project: Project = .test
    NavigationStack {
        ProjectDetailView(project: $project)
            .environment(TaskeandoVM(networkRepository: RepositoryTest()))
    }
}
