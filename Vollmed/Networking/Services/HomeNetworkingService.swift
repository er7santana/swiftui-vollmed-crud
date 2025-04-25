//
//  HomeNetworkingService.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

protocol HomeServiceable {
    func getAllSpecialists() async throws -> Result<[Specialist]?, RequestError>
}

struct HomeNetworkingService: HttpClient, HomeServiceable {
    
    func getAllSpecialists() async throws -> Result<[Specialist]?, RequestError> {
        return await sendRequest(endpoint: HomeEndpoint.getAllSpecialists, responseModel: [Specialist].self)
    }
    
    
}
