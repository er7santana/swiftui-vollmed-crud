//
//  Login.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password = "senha"
    }
}

struct LoginResponse: Identifiable, Codable {
    let auth: Bool
    let id: String
    let token: String
}
