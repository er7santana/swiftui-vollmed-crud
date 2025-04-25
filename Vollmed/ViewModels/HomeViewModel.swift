//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let service = WebService()
    var authManager = AuthenticationManager.shared
    @Published var specialists: [Specialist] = []
    
    func fetchSpecialists() async {
        do {
            if let specialists = try await service.getAllSpecialists() {
                self.specialists = specialists
            }
        } catch {
            print("Error fetching specialists: \(error)")
        }
    }
    
    func logout() async {
        do {
            if try await service.logoutPatient() {
                authManager.removeToken()
                authManager.removePatientID()
            }
        } catch {
            print("Error logging out: \(error)")
        }
    }
}
