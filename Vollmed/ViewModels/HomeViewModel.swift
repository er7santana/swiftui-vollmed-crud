//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    let homeService: HomeServiceable
    let authService: AuthServiceable
    let authManager = AuthenticationManager.shared
    @Published var specialists: [Specialist] = []
    @Published var isShowingSnackBar = false
    @Published var snackBarMessage: String = ""
    @Published var isFetchingData = false
    
    init(homeservice: HomeServiceable = HomeNetworkingService(),
         authService: AuthServiceable = AuthNetworkingService()) {
        self.homeService = homeservice
        self.authService = authService
    }
    
    func fetchSpecialists() async {
        isFetchingData = true
        defer { isFetchingData = false }
        do {
            let result = try await homeService.getAllSpecialists()
            switch result {
            case .success(let responseSpecialists):
                isShowingSnackBar = false
                if let responseSpecialists {
                    self.specialists = responseSpecialists
                }
            case .failure(let error):
                snackBarMessage = error.customMessage
                withAnimation {
                    isShowingSnackBar = true
                }
            }
        } catch {
            print("Error fetching specialists: \(error)")
            snackBarMessage = "Erro ao buscar especialistas"
            isShowingSnackBar = true
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
