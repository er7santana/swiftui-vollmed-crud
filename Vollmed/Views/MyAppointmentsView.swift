//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct MyAppointmentsView: View {
    
    let service = WebService()
    var authManager = AuthenticationManager.shared
    
    @State private var appointments: [Appointment] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if appointments.isEmpty {
                VStack {
                    
                    Image(systemName: "calendar.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.cancel)
                        .frame(width: 50, height: 50)
                        .padding(.top, 50)
                    
                    Text("Não há nenhuma consulta agendada no momento.")
                        .font(.title3.bold())
                        .foregroundStyle(.cancel)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            ForEach(appointments) { appointment in
                SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
            }
        }
        .padding()
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await getAllAppointments()
        }
    }
    
    func getAllAppointments() async {
        guard let patientID = authManager.patientID else {
            print("Patient ID not found in UserDefaults.")
            return
        }
        do {
            let appointments: [Appointment] = try await service.getAllAppointmentsFromPatient(patientID: patientID)
            self.appointments = appointments
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        MyAppointmentsView()
    }
}
