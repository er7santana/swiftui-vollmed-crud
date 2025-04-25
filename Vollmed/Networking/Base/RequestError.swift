//
//  RequestError.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case decodingError
    case serverError(_ message: String)
    case unknownError
    case custom(_ error: [String: Any])
    
    var customMessage: String {
        switch self {
            case .unauthorized:
                return "Você não está autorizado a acessar este recurso"
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .decodingError:
            return "Erro de decodificação"
        case .serverError(let message):
            return message
        case .unknownError:
            return "Ocorreu um erro desconhecido"
        case .custom(let error):
            if let message = error["message"] as? String {
                return message
            }
            return "Ocorreu um erro desconhecido"
        }
    }
}
