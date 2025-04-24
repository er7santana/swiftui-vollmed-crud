//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 23/04/25.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    var specialistId: String
    var appointmentId: String?
    
    var isRescheduling: Bool {
        appointmentId != nil
    }
    let service = WebService()
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var isAppointmentScheduled: Bool = false
    @State private var alertMessage: String = ""
    
    init(specialistId: String, appointmentId: String? = nil) {
        self.specialistId = specialistId
        self.appointmentId = appointmentId
    }
    
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
                    if isRescheduling {
                        await rescheduleAppointment()
                    } else {
                        await scheduleAppointment()
                    }
                }
            } label: {
                ButtonView(text: isRescheduling ? "Reagendar consulta" : "Agendar consulta")
            }
        }
        .padding()
        .navigationTitle(isRescheduling ? "Reagendar consulta" : "Agendar consulta")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isAppointmentScheduled ? "Sucesso" : "Ops, algo deu errado"),
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
        guard let patientID = UserDefaultsHelper.getValue(for: "patient-id") else { return }
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
    
    func rescheduleAppointment() async {
        guard let patientID = UserDefaultsHelper.getValue(for: "patient-id") else { return }
        guard let appointmentId else { return }
        isAppointmentScheduled = false
        defer { showAlert = true }
        do {
            let response = try await service.rescheduleAppointment(appointmentId: appointmentId, date: selectedDate.convertToString())
            isAppointmentScheduled = true
            alertMessage = "Consulta remarcada com sucesso para \(response.date.converDateStringToReadableDate())"
        } catch {
            print("Error rescheduling appointment: \(error.localizedDescription)")
            alertMessage = error.localizedDescription
        }
    }
}

#Preview("Scheduling Appointment") {
    NavigationStack {
        ScheduleAppointmentView(specialistId: Specialist.mockItem.id)
    }
}

#Preview("Rescheduling Appointment") {
    NavigationStack {
        ScheduleAppointmentView(specialistId: Specialist.mockItem.id, appointmentId: "xyz123")
    }
}
