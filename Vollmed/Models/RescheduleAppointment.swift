//
//  RescheduleAppointmentRequest.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

struct RescheduleAppointmentRequest: Codable {
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "data"
    }
}
