//
//  SignInViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 26/04/25.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    
    var service: AuthServiceable
    var authManager = AuthenticationManager.shared
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    
    init(service: AuthServiceable = AuthNetworkingService()) {
        self.service = service
    }
    
    @MainActor
    func signIn() async {
        do {
            let result = try await service.loginPatient(email: email, password: password)
            switch result {
            case .success(let response):
                authManager.saveToken(token: response.token)
                authManager.savePatientID(id: response.id)
            case .failure(let failure):
                print(failure.customMessage)
                showAlert = true
            }
        } catch {
            print("Error signing in: \(error)")
            showAlert = true
        }
    }
}
