//
//  AuthEndpoint.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

enum AuthEndpoint {
    case login(LoginRequest)
    case logout
    case signUp(Patient)
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .logout:
            return "/auth/logout"
        case .login:
            return "/auth/login"
        case .signUp:
            return "/paciente"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .logout, .login, .signUp:
            return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .logout:
            return nil
        case .login(let loginRequest):
            return loginRequest.dictionary
        case.signUp(let patient):
            return patient.dictionary
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .logout:
            guard let token = AuthenticationManager.shared.token else {
                return [:]
            }
            
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        case .login:
            return [
                "Content-Type": "application/json",
            ]
        case .signUp:
            return [
                "Content-Type": "application/json",
            ]
        }
    }
}
