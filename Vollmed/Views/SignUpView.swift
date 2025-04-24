//
//  SignUpView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var cpf: String = ""
    @State private var phoneNumber: String = ""
    @State private var healthPlan: String = ""
    @State private var password: String = ""
    
    var isFormFilled: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !cpf.isEmpty &&
        !phoneNumber.isEmpty &&
        !healthPlan.isEmpty &&
        !password.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 36, alignment: .center)
                    .padding(.vertical)
                
                Text("Olá, boas-vindas!")
                    .font(.title2.bold())
                    .foregroundStyle(.accent)
                
                Text("Insira seus dados para criar uma conta")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                Text("Nome")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu nome completo", text: $name)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                
                Text("E-mail")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu e-mail", text: $email)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                Text("CPF")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu CPF", text: $cpf)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .keyboardType(.numberPad)
                
                Text("Número de telefone")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu número de telefone", text: $phoneNumber)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .keyboardType(.phonePad)
                
                Text("Plano de saúde")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu plano de saúde", text: $healthPlan)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                
                Text("Senha")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                SecureField("Insira sua senha", text: $password)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if isFormFilled {
                    Button {
                        // Handle sign up action
                    } label: {
                        ButtonView(text: "Cadastrar")
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Já possui uma conta? Entre.")
                        .font(.body.bold())
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationView {
        SignUpView()
    }
}
