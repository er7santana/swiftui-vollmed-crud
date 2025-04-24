//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 23/04/25.
//

import SwiftUI

let patientID = "3f6d3158-b375-45ed-b242-db0403a0ba38"

struct ScheduleAppointmentView: View {
    
    var specialistId: String
    let service = WebService()
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var isAppointmentScheduled: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            Text("Selecione a data e o horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
            
            
            Spacer()
            
            Button {
                Task {
                    await scheduleAppointment()
                }
            } label: {
                ButtonView(text: "Agendar consulta")
            }
        }
        .padding()
        .navigationTitle("Agendar consulta")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isAppointmentScheduled ? "Sucesso" : "Erro ao agendar consulta"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK, Entendi"), action: {
                    if isAppointmentScheduled {
                        dismiss()
                    }
                })
            )
        }
    }
    
    func scheduleAppointment() async {
        isAppointmentScheduled = false
        defer { showAlert = true }
        do {
            let response = try await service.scheduleAppointment(specialistID: specialistId, patientID: patientID, date: selectedDate.convertToString())
            isAppointmentScheduled = true
            alertMessage = "Consulta agendada com sucesso para \(response.date.converDateStringToReadableDate())"
        } catch {
            print("Error scheduling appointment: \(error.localizedDescription)")
            alertMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationView {
        ScheduleAppointmentView(specialistId: Specialist.mockItem.id)
    }
}
