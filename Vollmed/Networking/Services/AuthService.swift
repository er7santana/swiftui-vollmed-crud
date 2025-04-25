//
//  AuthService.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

protocol AuthServiceable {
    func logoutPatient() async throws -> Result<Bool?, RequestError>
}

struct AuthNetworkingService: HttpClient, AuthServiceable {
    func logoutPatient() async throws -> Result<Bool?, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.logout, responseModel: nil)
    }
}
