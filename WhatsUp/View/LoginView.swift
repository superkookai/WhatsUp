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
    @State private var showSignUp = false
    
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }
    
    private func login() async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            appState.userSession = result.user
        } catch {
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Eamil", text: $email)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                
                Button {
                    Task {
                        await login()
                    }
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                
                HStack {
                    Text("Have no account?")
                    
                    Button {
                        showSignUp = true
                    } label: {
                        Text("SignUp")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .alert("Error Login", isPresented: $hasError) {
            
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignupView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
