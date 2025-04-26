//
//  HttpClient.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

protocol HttpClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type?) async -> Result<T?, RequestError>
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HttpClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type?) async -> Result<T?, RequestError> {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = 3000 // Quebra de padrão
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return .failure(.decodingError)
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let responseModel else {
                    return .success(nil)
                }
                
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decodingError)
                }
                
                return .success(decodedResponse)
                
            case 400:
                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .failure(.serverError(decodedError.message))
                }
                
                if let decodedError = try? JSONDecoder().decode(SecondErrorResponse.self, from: data) {
                    return .failure(.serverError(decodedError.error))
                }
                
                if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    return .failure(.custom(errorResponse))
                }
                
                return .failure(.invalidResponse)
                
            case 401:
                return .failure(.unauthorized)
                
            default:
                return .failure(.unknownError)
            }
        } catch {
            return .failure(.unknownError)
        }
    }
    
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = 3000 // Quebra de padrão
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return .failure(.decodingError)
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decodingError)
                }
                
                return .success(decodedResponse)
                
            case 400:
                if let decodedError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .failure(.serverError(decodedError.message))
                }
                
                if let decodedError = try? JSONDecoder().decode(SecondErrorResponse.self, from: data) {
                    return .failure(.serverError(decodedError.error))
                }
                
                if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    return .failure(.custom(errorResponse))
                }
                
                return .failure(.invalidResponse)
                
            case 401:
                return .failure(.unauthorized)
                
            default:
                return .failure(.unknownError)
            }
        } catch {
            return .failure(.unknownError)
        }
    }
}
