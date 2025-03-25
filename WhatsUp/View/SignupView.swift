//
//  SignupView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    @State private var errorMessage: String = ""
    @State private var hasError: Bool = false
    
    @EnvironmentObject private var model: Model
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !displayName.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await model.updateDisplayName(for: result.user, displayName: displayName)
            
        } catch {
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.title.weight(.bold))
            Form {
                TextField("Eamil", text: $email)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                TextField("Display Name", text: $displayName)
                
                
                Button {
                    Task {
                        await signUp()
                    }
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                
                HStack {
                    Text("Alredy have account?")
                    
                    Button {
                        
                    } label: {
                        Text("Login")
                    }

                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Sign Up Error", isPresented: $hasError) {
            
        } message: {
            Text(errorMessage)
        }

    }
}

#Preview {
    SignupView()
        .environmentObject(Model())
}
