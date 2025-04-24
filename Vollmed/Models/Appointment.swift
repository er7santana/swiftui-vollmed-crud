//
//  Appointment.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

struct Appointment: Codable, Identifiable {
    let id: String
    let specialist: Specialist
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case specialist = "especialista"
        case date = "data"
    }
}
