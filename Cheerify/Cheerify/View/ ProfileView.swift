//
//   ProfileView.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI
import FirebaseAuth

// MARK: PROFILE VIEW
struct ProfileView: View {
    
    // STATE PRIVATE PROPERTIES
    @State private var navigateToLogin: Bool = false
    @State private var email: String? = nil
    @State private var accountCreationDate: String? = nil
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccess: Bool = false
    @State private var successMessage: String = ""
    
    // STATE OBJECT for view model
    @StateObject private var profileVM = ProfileViewModel()
    
    // BODY VIEW
    var body: some View {
        NavigationStack {
            ZStack {
                
                // BGM, changing based on dark or light mode
                if profileVM.isDarkMode {
                    AppColors.darkGradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                } else {
                    AppColors.gradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                }
                
                VStack {
                    Text("SETTING")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    if let userEmail = email, let creationDate = accountCreationDate {
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.customOrange)
                                    .frame(width: 170, height: 170)
                                    .opacity(0.5)
                                // Display the initial profile picture
                                Text(profileVM.getInitial(from: userEmail))
                                    .font(.system(size: 64, weight: .bold))
                                    .foregroundStyle(.customOrange)
                                    .frame(width: 130, height: 130)
                                    .background(.lightBeige)
                                    .clipShape(Circle())
                            }
                            
                            // Display the user email
                            Text("\(userEmail)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            // Display the account creation date
                            Text("Date joined on \(creationDate)")
                                .font(.headline)
                                .padding(.bottom, 20)
                        }
                    } else {
                        // Showing the placeholder when there is no user logged in
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.customOrange)
                                    .frame(width: 170, height: 170)
                                    .opacity(0.5)
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                            }
                            .padding(.bottom, 20)
                            
                            Text("ExampleUser.com")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            Text("Date joined on 23/10/2024")
                                .font(.headline)
                                .padding(.bottom, 20)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        // Button to reset password
                        Button {
                            resetPassword()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(.customBlack)
                                
                                Text("Reset Password")
                                    .foregroundStyle(.customBlack)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical)
                                
                                // Pushing all the elements to the left
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(.lightBeige)
                        .cornerRadius(10)
                        .padding(.top, 15)
                        // Displaying the alert to display the password reset link has been sent message
                        .alert(isPresented: $showSuccess) {
                            Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Button to enable the dark and light display modes
                    HStack {
                        Toggle(isOn: profileVM.$isDarkMode) {
                            HStack {
                                // Display the icons
                                Image(systemName: "circle.righthalf.fill")
                                    .foregroundStyle(.customBlack)
                                
                                // Display the enable night mode text
                                Text("Display Mode")
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical)
                            }
                        }
                        // Give the customise colour for the toggle
                        .toggleStyle(SwitchToggleStyle(tint:.button))
                    }
                    .padding(.horizontal, 10)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.lightBeige)
                    .cornerRadius(10)
                    // Calling the update color scheme function
                    .onChange(of: profileVM.isDarkMode) { newValue, _ in
                        profileVM.updateColorScheme()
                    }
                    Spacer()
                    
                    // Button to sign out
                    Button {
                        try! Auth.auth().signOut()
                        // Update the user status after sign out
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                        profileVM.setAppToLightMode()
                        navigateToLogin = true
                    } label :{
                        Text("Log out")
                            .foregroundStyle(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(.button)
                    .cornerRadius(20)
                    .padding(.top, 15)
                    
                    // Button to delete account
                    Button {
                        deleteAccount()
                    } label: {
                        Text("Delete Account")
                            .foregroundStyle(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(.cherry)
                    .cornerRadius(20)
                    .padding(.top, 15)
                    // Display the alert before deleting the account permanently
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    // Push the buttons so that it is not clashed with the tab view
                    Spacer()
                }
                // Once this view appears, it will fetch the user email
                .onAppear {
                    fetchUserEmail()
                }
            }
            // It will navigate back to the login view
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    // PRIVATE FUNCTTION to fetch the user email from Firebase Auth
    private func fetchUserEmail() {
        if let user = Auth.auth().currentUser {
            email = user.email
            let creationDate = user.metadata.creationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            // Format the creation date
            if let creationDate = creationDate {
                accountCreationDate = dateFormatter.string(from: creationDate)
            } else {
                // ERROR HANDLING if creation date is unavailable
                accountCreationDate = "Unavailable"
            }
        } else {
            // ERROR HANDLING if the user is not found
            email = "No user found"
        }
    }
    
    // PRIVATE FUNCTION to delete account
    private func deleteAccount() {
        // ERROR HANDLING to check the current logged in user
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user found"
            showError = true
            return
        }
        
        user.delete { error in
            if let error = error {
                // ERROR HANDLING if delete account is failed
                errorMessage = "Failed to delete account: \(error.localizedDescription)"
                showError = true
            } else {
                // Updated the user status
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                profileVM.setAppToLightMode()
                // Account deleted then log out and navigate to login screen
                navigateToLogin = true
            }
        }
    }
    
    // PRIVATE FUNCTION to reset password
    private func resetPassword() {
        // ERROR HANDLING if there is no email
        guard let email = email else {
            errorMessage = "No email associated with the account"
            showError = true
            return
        }
        
        // Reset password function from Firebase Auth
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            // ERROR HANDLING if it is failed to reset password
            if let error = error {
                errorMessage = "Failed to send reset email: \(error.localizedDescription)"
                showError = true
            } else {
                successMessage = "The reset password link has been sent to your email"
                showSuccess = true
            }
        }
    }
}

// MARK: PROFILE PREVIEW
#Preview {
    ProfileView()
}
