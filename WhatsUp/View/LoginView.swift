//
//  LoginView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var hasError: Bool = false
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }
    
    private func login() async {
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            //Go to MainView
        } catch {
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title.weight(.bold))
            Form {
                TextField("Eamil", text: $email)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                
                Button {
                    
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                
                HStack {
                    Text("Have no account?")
                    
                    Button {
                        
                    } label: {
                        Text("SignUp")
                    }

                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Error Login", isPresented: $hasError) {
            
        } message: {
            Text(errorMessage)
        }

    }
}

#Preview {
    LoginView()
}
