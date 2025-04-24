//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct MyAppointmentsView: View {
    
    let service = WebService()
    
    @State private var appointments: [Appointment] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(appointments) { appointment in
                SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
            }
        }
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await getAllAppointments()
        }
    }
    
    func getAllAppointments() async {
        do {
            let appointments: [Appointment] = try await service.getAllAppointmentsFromPatient(patientID: patientID)
            self.appointments = appointments
        } catch {
            print("Error fetching appointments: \(error)")
        }
    }
}

#Preview {
    NavigationView {
        MyAppointmentsView()
    }
}
