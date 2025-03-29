//
//  SetttingsView.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 25/03/2568.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SetttingsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var model: Model
    
    @State private var settingsConfig = SettingsConfig()
    @State private var currentPhotoURL: URL? = Auth.auth().currentUser?.photoURL
    @State private var showSaveAlert: Bool = false
    @FocusState var isEditing: Bool
    
    var displayName: String {
        appState.userSession?.displayName ?? "Guest"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: currentPhotoURL) { image in
                    image
                        .rounded()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .rounded()
                }
                .onTapGesture {
                    settingsConfig.showPhotoOptions = true
                }
                .confirmationDialog("Select", isPresented: $settingsConfig.showPhotoOptions) {
                    
                    Button("Camera") {
                        settingsConfig.sourceType = .camera
                    }
                    
                    Button("Photo Library") {
                        settingsConfig.sourceType = .photoLibrary
                    }
                }
                .padding(.bottom, 20)
                
                TextField(settingsConfig.displayName, text: $settingsConfig.displayName)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 10))
                    .textInputAutocapitalization(.never)
                    .focused($isEditing)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        signOut()
                    } label: {
                        Text("SignOut")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        save()
                    } label: {
                        Text("Save")
                    }

                }
            }
            .sheet(item: $settingsConfig.sourceType, content: { sourceType in
                ImagePicker(image: $settingsConfig.selectedImage, sourceType: sourceType)
            })
            .onChange(of: settingsConfig.selectedImage, { _, image in
                guard let image,
                      let resizedImage = image.resize(to: CGSize(width: 100, height: 100)),
                      let imageData = resizedImage.pngData() else { return }
                
                Task {
                    guard let currentUser = appState.userSession else { return }
                    let fileName = "\(currentUser.uid).png"
                    do {
                        let downloadURL = try await Storage.storage().uploadData(for: fileName, data: imageData, bucket: .photos)
                        try await model.uploadPhotoURL(for: currentUser, photoURL: downloadURL)
                        currentPhotoURL = downloadURL
                    } catch {
                        print("Error upload photo: \(error)")
                    }
                }
                
            })
            .onAppear {
                settingsConfig.displayName = displayName
            }
            .alert("Save Display Name", isPresented: $showSaveAlert) {
                Button("OK") {}
            }
        }
    }
    
    private func save() {
        guard let currentUser = appState.userSession else { return }
        Task {
            do {
                try await model.updateDisplayName(for: currentUser, displayName: settingsConfig.displayName)
                showSaveAlert = true
            } catch {
                print("Error updating displayName: \(error.localizedDescription)")
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            appState.userSession = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SetttingsView()
        .environmentObject(AppState())
        .environmentObject(Model())
}
