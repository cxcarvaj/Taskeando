struct TaskDetailView: View {
    let task: ProjectTask
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Título de la tarea
                Text(task.title)
                    .font(.title)
                    .bold()
                
                // Descripción
                if let description = task.description, !description.isEmpty {
                    Text("Descripción")
                        .font(.headline)
                    Text(description)
                        .font(.body)
                }
                
                // Fecha de vencimiento
                if let dueDate = task.dueDate {
                    Text("Fecha de vencimiento")
                        .font(.headline)
                    Text(dueDate, style: .date)
                        .font(.body)
                }
                
                // Estado
                Text("Estado")
                    .font(.headline)
                Text(task.status.rawValue)
                    .font(.body)
                    .padding(6)
                    .background(statusColor(for: task.status).opacity(0.2))
                    .cornerRadius(8)
                
                // Asignado a
                if let assignee = task.assignee {
                    Text("Asignado a")
                        .font(.headline)
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                        Text(assignee.name)
                            .font(.body)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalles de la Tarea")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Función para determinar el color según el estado
    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .notStarted:
            return .gray
        case .inProgress:
            return .blue
        case .completed:
            return .green
        case .delayed:
            return .orange
        }
    }
}

// Esto asume que tienes un enum TaskStatus
enum TaskStatus: String {
    case notStarted = "No iniciada"
    case inProgress = "En progreso"
    case completed = "Completada"
    case delayed = "Retrasada"
}