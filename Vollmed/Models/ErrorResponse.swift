//
//  ErrorResponse.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let message: String
}

struct SecondErrorResponse: Codable {
    let error: String
}
