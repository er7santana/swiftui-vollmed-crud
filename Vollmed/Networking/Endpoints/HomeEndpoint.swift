//
//  HomeEndpoint.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

enum HomeEndpoint {
    case getAllSpecialists
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getAllSpecialists:
            return "/especialista"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getAllSpecialists:
            return .get
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .getAllSpecialists:
            return nil
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .getAllSpecialists:
            return [:]
        }
    }
}
