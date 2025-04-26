//
//  SignUpViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 26/04/25.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    
    var service: AuthNetworkingService
    
    init(service: AuthNetworkingService = AuthNetworkingService()) {
        self.service = service
    }
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var cpf: String = ""
    @Published var phoneNumber: String = ""
    @Published var healthPlan: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var registered: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToSignIn: Bool = false
    
    var isFormFilled: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !cpf.isEmpty &&
        !phoneNumber.isEmpty &&
        !healthPlan.isEmpty &&
        !password.isEmpty
    }
    
    let healthPlans = [
        "Amil",
        "Bradesco Saúde",
        "SulAmérica",
        "Unimed",
        "Hapvida",
        "Outro"
    ]
    
    @MainActor
    func register() async {
        registered = false
        defer { showAlert = true }
        let patient = Patient(
            id: nil,
            cpf: cpf,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            healthPlan: healthPlan,
        )
        do {
            let result = try await service.signUp(patient: patient)
            switch result {
            case .success:
                registered = true
                alertMessage = "Você já pode fazer login."
            case .failure(let error):
                alertMessage = error.customMessage
                print(error.localizedDescription)
            }
        } catch {
            alertMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func resetForm() {
        healthPlan = healthPlans[0]
    }
}
