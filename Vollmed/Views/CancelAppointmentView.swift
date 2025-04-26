//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct CancelAppointmentView: View {

    let service = AppointmentsService()
    let appointmentId: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var reasonToCancel: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var canceled: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Conte-nos o motivo do cancelamento da sua consulta")
                .font(.title3.bold())
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            if #available(iOS 16.0, *) {
                TextEditor(text: $reasonToCancel)
                    .padding()
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .scrollContentBackground(.hidden)
                    .background(Color(.lightBlue).opacity(0.15))
                    .cornerRadius(16)
                    .frame(maxHeight: 300)
            } else {
                TextEditor(text: $reasonToCancel)
                    .padding()
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .background(Color(.lightBlue).opacity(0.15))
                    .cornerRadius(16)
                    .frame(maxHeight: 300)
            }
            
            if reasonToCancel.isEmpty {
                Text("Motivo é obrigatório")
                    .foregroundColor(.red)
            } else {
                Button {
                    Task {
                        await cancelAppointment()
                    }
                } label: {
                    ButtonView(text: "Cancelar consulta", buttonType: .cancel)
                }
            }
        }
        .padding()
        .navigationTitle("Cancelar consuta")
        .navigationBarTitleDisplayMode(.inline)
        .alert(canceled ? "Sucesso" : "Ops, algo deu errado", isPresented: $showAlert) {
            Button("OK") {
                if canceled {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    func cancelAppointment() async {
        canceled = false
        defer { showAlert = true }
        do {
            let response = try await service.cancelAppointment(appointmentId: appointmentId, reason: reasonToCancel)
            self.alertMessage = response
            self.canceled = true
            
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}

#Preview {
    CancelAppointmentView(appointmentId: "xpto456")
}
