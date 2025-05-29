//
//  AddProjectVM.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 29/5/25.
//


import SwiftUI

@Observable
final class AddProjectVM {
    var name: String = ""
    var summary: String = ""
    var type: ProjectType = .none
    var state: TaskState = .none
    
    func getProject() -> Project {
        Project(id: nil, name: name, summary: summary, type: type, state: state)
    }
}
