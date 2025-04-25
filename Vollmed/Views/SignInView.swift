//
//  SignInView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct SignInView: View {
    
    let service = WebService()
    
    var authManager = AuthenticationManager.shared
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 36, alignment: .center)
            
            Text("E-mail")
                .font(.title3.bold())
                .foregroundStyle(.accent)
                .padding(.top, 40)
            
            TextField("Insira seu e-mail", text: $email)
                .padding(14)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(14)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            Text("Senha")
                .font(.title3.bold())
                .foregroundStyle(.accent)
            
            SecureField("Insira sua senha", text: $password)
                .padding(14)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(14)
            
            Button {
                Task {
                    await signIn()
                }
            } label: {
                ButtonView(text: "Entrar")
            }
            
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
        .alert("Ops, algo deu errado", isPresented: $showAlert) {
            Button(action: { }, label: {
                Text("OK, entendi!")
            })
        } message: {
            Text("Verifique seus dados e tente novamente.")
        }

    }
    
    func signIn() async {
        do {
            let response = try await service.loginPatient(email: email, password: password)
            print("User signed in: \(response)")
            authManager.saveToken(token: response.token)
            authManager.savePatientID(id: response.id)
        } catch {
            print("Error signing in: \(error)")
            showAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
