//
//  AuthenticationManager.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

class AuthenticationManager: ObservableObject {
    
    static let shared = AuthenticationManager()
    
    @Published var token: String?
    @Published var patientID: String?
    
    private init() {
        self.token = KeychainHelper.getValue(for: "app-vollmed-token")
        self.patientID = KeychainHelper.getValue(for: "app-vollmed-patient-id")
    }
    
    func saveToken(token: String) {
        KeychainHelper.save(value: token, key: "app-vollmed-token")
        DispatchQueue.main.async {
            self.token = token
        }
    }

    func removeToken() {
        KeychainHelper.remove(for: "app-vollmed-token")
        DispatchQueue.main.async {
            self.token = nil
        }
    }

    func savePatientID(id: String) {
        KeychainHelper.save(value: id, key: "app-vollmed-patient-id")
        DispatchQueue.main.async {
            self.patientID = id
        }
    }

    func removePatientID() {
        KeychainHelper.remove(for: "app-vollmed-patient-id")
        DispatchQueue.main.async {
            self.patientID = nil
        }
    }

}
