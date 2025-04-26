//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct MyAppointmentsView: View {
    
    @ObservedObject var viewModel = MyAppointmentsViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.appointments.isEmpty {
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
            ForEach(viewModel.appointments) { appointment in
                SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
            }
        }
        .padding()
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getAllAppointments()
        }
    }
}

#Preview {
    NavigationStack {
        MyAppointmentsView()
    }
}
