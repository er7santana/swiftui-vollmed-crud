//
//  SignUpView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        self.viewModel = viewModel
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
                
                TextField("Insira seu nome completo", text: $viewModel.name)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                
                Text("E-mail")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu e-mail", text: $viewModel.email)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                Text("CPF")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu CPF", text: $viewModel.cpf)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .keyboardType(.numberPad)
                
                Text("Número de telefone")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                TextField("Insira seu número de telefone", text: $viewModel.phoneNumber)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .keyboardType(.phonePad)
                
                Text("Selecione seu plano de saúde")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                Picker("Plano de saúde", selection: $viewModel.healthPlan) {
                    ForEach(viewModel.healthPlans, id: \.self) { plan in
                        Text(plan)
                            .tag(plan)
                    }
                }
                
                Text("Senha")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                SecureField("Insira sua senha", text: $viewModel.password)
                    .padding(14)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(14)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if viewModel.isFormFilled {
                    Button {
                        Task {
                            await viewModel.register()
                        }
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
        .onAppear {
            viewModel.resetForm()
        }
        .alert(viewModel.registered ? "Sucesso" : "Ops, algo deu errado", isPresented: $viewModel.showAlert) {
            Button("OK, Entendi") {
                if viewModel.registered {
                    viewModel.navigateToSignIn = true
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .navigationDestination(isPresented: $viewModel.navigateToSignIn) {
            SignInView()
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
