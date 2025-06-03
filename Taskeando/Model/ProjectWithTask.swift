//
//  ProjectWithTask.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 2/6/25.
//

import Foundation

struct ProjectWithTask: Identifiable {
    let id = UUID()
    let project: Project
    let task: ProjectTask
}
