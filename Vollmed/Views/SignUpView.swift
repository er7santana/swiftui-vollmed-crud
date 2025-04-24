//
//  SignUpView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import SwiftUI

struct SignUpView: View {
    
    let service = WebService()
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var cpf: String = ""
    @State private var phoneNumber: String = ""
    @State private var healthPlan: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var registered: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn: Bool = false
    
    let healthPlans = [
        "Amil",
        "Bradesco Saúde",
        "SulAmérica",
        "Unimed",
        "Hapvida",
        "Outro"
    ]
    
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
                
                Text("Selecione seu plano de saúde")
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
                
                Picker("Plano de saúde", selection: $healthPlan) {
                    ForEach(healthPlans, id: \.self) { plan in
                        Text(plan)
                            .tag(plan)
                    }
                }
                
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
                        Task {
                            await register()
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
            healthPlan = healthPlans[0]
        }
        .alert(registered ? "Sucesso" : "Ops, algo deu errado", isPresented: $showAlert) {
            Button("OK, Entendi") {
                if registered {
                    navigateToSignIn = true
                }
            }
        } message: {
            Text(alertMessage)
        }
        .navigationDestination(isPresented: $navigateToSignIn) {
            SignInView()
        }
    }
    
    func register() async {
        registered = false
        defer { showAlert = true }
        let patient = Patient(
            id: nil,
            cpf: cpf,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            healthPlan: healthPlan,
        )
        do {
            let response = try await service.registerPatient(patient: patient)
            registered = true
            alertMessage = "Você já pode fazer login."
        } catch {
            alertMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
