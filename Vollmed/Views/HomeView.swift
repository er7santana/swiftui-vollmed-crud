//
//  HomeView.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import SwiftUI

struct HomeView: View {
    
    var service = WebService()
    
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.vertical, 32)
                    Text("Boas-vindas!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(.lightBlue))
                    Text("Veja abaixo os especialistas da Vollmed disponíveis e marque já a sua consulta!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    if viewModel.isFetchingData {
                        SkeletonView()
                    } else {
                        ForEach(viewModel.specialists) { specialist in
                            SpecialistCardView(specialist: specialist)
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .task {
                await viewModel.fetchSpecialists()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.logout()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sair")
                        }
                    }
                }
            }
            if viewModel.isShowingSnackBar {
                SnackBarView(isShowing: $viewModel.isShowingSnackBar, message: viewModel.snackBarMessage)
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
