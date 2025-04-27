//
//  SignInView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI
import VollMedUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel = SignInViewModel()) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 36, alignment: .center)
            
            Text("E-mail")
                .titleMdBoldStyle()
                .padding(.top, 40)
            
            TextField("Insira seu e-mail", text: $viewModel.email)
                .padding(14)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(14)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            Text("Senha")
                .titleMdBoldStyle()
            
            SecureField("Insira sua senha", text: $viewModel.password)
                .padding(14)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(14)
            
            Button("Entrar") {
                Task {
                    await viewModel.signIn()
                }
            }
            .buttonStyle(ConfirmPrimaryButtonStyle())
            
            NavigationLink {
                SignUpView()
            } label: {
                Text("Ainda não possui uma conta? Cadastre-se.")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 8)
        }
        .padding()
        .navigationBarBackButtonHidden()
        .alert("Ops, algo deu errado", isPresented: $viewModel.showAlert) {
            Button(action: { }, label: {
                Text("OK, entendi!")
            })
        } message: {
            Text("Verifique seus dados e tente novamente.")
        }

    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
