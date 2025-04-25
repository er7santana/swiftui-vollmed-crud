//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let homeService: HomeServiceable
    let authService: AuthServiceable
    let authManager = AuthenticationManager.shared
    @Published var specialists: [Specialist] = []
    
    init(homeservice: HomeServiceable = HomeNetworkingService(),
         authService: AuthServiceable = AuthNetworkingService()) {
        self.homeService = homeservice
        self.authService = authService
    }
    
    func fetchSpecialists() async {
        do {
            let result = try await homeService.getAllSpecialists()
            switch result {
            case .success(let responseSpecialists):
                if let responseSpecialists {
                    DispatchQueue.main.async {
                        self.specialists = responseSpecialists
                    }
                }
            case .failure(let error):
                print("Error fetching specialists: \(error)")
            }
        } catch {
            print("Error fetching specialists: \(error)")
        }
    }
    
    func logout() async {
        do {
            let result = try await authService.logoutPatient()
            switch result {
            case .success:
                authManager.removeToken()
                authManager.removePatientID()
            case .failure(let requestError):
                print(requestError.localizedDescription)
            }
        } catch {
            print("Error logging out: \(error)")
        }
    }
}
