//
//  AppointmentsService.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 26/04/25.
//

import Foundation

let baseURL = "http://localhost:3000"

protocol AppointmentsServiceable {
    func getAllAppointmentsFromPatient(patientID: String) async throws -> [Appointment]
    func rescheduleAppointment(appointmentId: String, date: String) async throws -> ScheduleAppointmentResponse
    func cancelAppointment(appointmentId: String, reason: String) async throws -> String
    func scheduleAppointment(specialistID: String, patientID: String, date: String) async throws -> ScheduleAppointmentResponse
}

struct AppointmentsService: AppointmentsServiceable {
    
    var authManager = AuthenticationManager.shared
    func getAllAppointmentsFromPatient(patientID: String) async throws -> [Appointment] {
        let endpoint = "\(baseURL)/paciente/\(patientID)/consultas"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        guard let token = AuthenticationManager.shared.token else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let appointments = try JSONDecoder().decode([Appointment].self, from: data)
        return appointments
    }
    
    func rescheduleAppointment(appointmentId: String, date: String) async throws -> ScheduleAppointmentResponse {
        let endpoint = baseURL + "/consulta/\(appointmentId)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        guard let token = authManager.token else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let appointment = RescheduleAppointmentRequest(date: date)
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
            return appointmentResponse
        } catch {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NSError(domain: "WebServiceError", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
        }
    }
    
    func cancelAppointment(appointmentId: String, reason: String) async throws -> String {
        let endpoint = baseURL + "/consulta/\(appointmentId)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        guard let token = authManager.token else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let bodyDictionary = ["motivo_cancelamento": reason]
        let jsonData = try JSONSerialization.data(withJSONObject: bodyDictionary, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let appointmentResponse = try JSONDecoder().decode(String.self, from: data)
            return appointmentResponse
        } catch {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NSError(domain: "WebServiceError", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
        }
    }
    
    func scheduleAppointment(specialistID: String, patientID: String, date: String) async throws -> ScheduleAppointmentResponse {
        let endpoint = baseURL + "/consulta"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        guard let token = authManager.token else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let appointment = ScheduleAppointmentRequest(specialist: specialistID, patient: patientID, date: date)
        let jsonData = try JSONEncoder().encode(appointment)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
            
            return appointmentResponse
        } catch {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NSError(domain: "WebServiceError", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
        }
    }
    
}
    
