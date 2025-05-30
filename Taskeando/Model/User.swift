//
//  User.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 22/5/25.
//


import Foundation

struct User: Codable, Identifiable, Hashable {
    var id: String { email }

    let email: String
    let name: String
    let avatar: String?
}
