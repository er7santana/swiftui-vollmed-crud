//
//  MyAppointmentsViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 26/04/25.
//

import SwiftUI

@MainActor
class MyAppointmentsViewModel: ObservableObject {
    
    let service = AppointmentsService()
    var authManager = AuthenticationManager.shared
    
    @Published var appointments: [Appointment] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func getAllAppointments() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        
        guard let patientID = authManager.patientID else {
            print("Patient ID not found in UserDefaults.")
            return
        }
        do {
            let appointments = try await service.getAllAppointmentsFromPatient(patientID: patientID)
            self.appointments = appointments
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }
}
