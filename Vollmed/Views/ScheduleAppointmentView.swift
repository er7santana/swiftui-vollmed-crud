//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 23/04/25.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    let specialist: Specialist
    
    @State private var selectedDate: Date = Date()
    
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
                print(selectedDate.convertToString())
                print(selectedDate.convertToString().converDateStringToReadableDate())
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
    }
}

#Preview {
    NavigationStack {
        ScheduleAppointmentView(specialist: Specialist.mockItem)
    }
}
