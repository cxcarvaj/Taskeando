//
//  UserDTO.swift
//  Taskeando
//
//  Created by Carlos Xavier Carvajal Villegas on 22/5/25.
//


import Foundation

struct UserDTO: Codable {
    let email: String
    let password: String
    let name: String
    let avatar: String?
    let role: UserType
}

struct Token: Codable {
    var token: String
}
