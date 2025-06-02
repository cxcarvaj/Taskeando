//
//  ProjectDetailVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//

import Foundation

@Observable
final class ProjectDetailVM {
    var type: ProjectType = .none
    var state: TaskState = .none
    
    func setProjectType(_ type: ProjectType) {
        self.type = type
    }
    
    func setTaskState(_ state: TaskState) {
        self.state = state
    }
}
