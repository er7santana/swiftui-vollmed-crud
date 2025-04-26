//
//  AuthService.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

protocol AuthServiceable {
    func logoutPatient() async throws -> Result<Bool?, RequestError>
    func loginPatient(email: String, password: String) async throws -> Result<LoginResponse, RequestError>
    func signUp(patient: Patient) async throws -> Result<Patient, RequestError>
}

struct AuthNetworkingService: HttpClient, AuthServiceable {
    func loginPatient(email: String, password: String) async throws -> Result<LoginResponse, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.login(LoginRequest(email: email, password: password)), responseModel: LoginResponse.self)
    }
    
    func logoutPatient() async throws -> Result<Bool?, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.logout, responseModel: nil)
    }
    
    func signUp(patient: Patient) async throws -> Result<Patient, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.signUp(patient), responseModel: Patient.self)
    }
}
