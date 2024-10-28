//
//   ProfileView.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI
import FirebaseAuth

// MARK: - Profile View Struct
struct ProfileView: View {
    
    // State private properties
    @State private var navigateToLogin: Bool = false
    @State private var email: String? = nil
    @State private var accountCreationDate: String? = nil
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccess: Bool = false
    @State private var successMessage: String = ""
    @State private var showAlert = false
    @State private var isNotificationSetUp = false
    
    // State object of ProfileViewModel
    @StateObject private var profileVM = ProfileViewModel()
    // Handle the notification
    let notificationHandler = NotificationHandler()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                
                // MARK: - Dark mode set up
                // BGM, changing based on dark or light mode
                if profileVM.isDarkMode {
                    AppColors.darkGradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                } else {
                    AppColors.gradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                }
                
                VStack {
                    // MARK: - Title
                    Text("SETTING")
                        .font(.custom("FiraMono-Medium", size: 40))
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                    
                    // MARK: - Show information if the user has registered
                    if let userEmail = email, let creationDate = accountCreationDate {
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .customOrange)
                                    .frame(width: 170, height: 170)
                                    .opacity(0.5)
                                // Display the initial profile picture
                                Text(profileVM.getInitial(from: userEmail))
                                    .font(.system(size: 64, weight: .bold))
                                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .customOrange)
                                    .frame(width: 130, height: 130)
                                    .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                                    .clipShape(Circle())
                            }
                            
                            // MARK: - Display user email
                            Text("\(userEmail)")
                                .font(.title2)
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            // MARK: - Display the account creation date
                            Text("Date joined on \(creationDate)")
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                .font(.headline)
                                .padding(.bottom, 5)
                        }
                    } else {
                        // MARK: - Placeholder
                        // Showing the placeholder when there is no user logged in
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .customOrange)
                                    .frame(width: 170, height: 170)
                                    .opacity(0.5)
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                            }
                            .padding(.bottom, 5)
                            
                            // MARK: - Display sample email
                            Text("ExampleUser.com")
                                .font(.title2)
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            // MARK: - Display sample creation date
                            Text("Date joined on 23/10/2024")
                                .font(.headline)
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                .padding(.bottom, 5)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        // MARK: - Reset password button
                        Button {
                            resetPassword()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                
                                Text("Reset Password")
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.vertical)
                                
                                // Pushing all the elements to the left
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                        .cornerRadius(10)
                        .padding(.top, 10)
                        // Displaying the alert to display the password reset link has been sent message
                        .alert(isPresented: $showSuccess) {
                            Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // MARK: - Button to enable the dark and light display modes
                    HStack {
                        Toggle(isOn: profileVM.$isDarkMode) {
                            HStack {
                                // Display the icons
                                Image(systemName: "circle.righthalf.fill")
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                
                                // Display the enable night mode text
                                Text("Display Mode")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                    .padding(.vertical)
                            }
                        }
                        // Give the customise colour for the toggle
                        .toggleStyle(SwitchToggleStyle(tint:.button))
                    }
                    .padding(.horizontal, 10)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                    .cornerRadius(10)
                    // Calling the update color scheme function
                    .onChange(of: profileVM.isDarkMode) { newValue, _ in
                        profileVM.updateColorScheme()
                    }
                    
                    // MARK: - Button to set up the notification
                    Button {
                        if isNotificationSetUp {
                            // Cancel notifications
                            notificationHandler.cancelAllNotifications()
                            isNotificationSetUp = false
                        } else {
                            // Set up notifications
                            notificationHandler.requestNotificationPermission { success in
                                if success {
                                    isNotificationSetUp = true
                                    showAlert = true
                                }
                            }
                        }
                    } label:  {
                        HStack {
                            Image(systemName: isNotificationSetUp ? "bell.slash" : "bell")
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            Text(isNotificationSetUp ? "Cancel Notification Setup" : "Set Up Notification")
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                .multilineTextAlignment(.leading)
                                .padding(.vertical)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("You have successfully set up the notification in the application."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .padding(.bottom, 15)
                    
                    // MARK: - Button to sign out
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
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    // MARK: - Button to delete account
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
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
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
    
    // MARK: - Fetch User Email Function
    // Fetch the user email from Firebase Auth
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
                // Error Handling if creation date is unavailable
                accountCreationDate = "Unavailable"
            }
        } else {
            // Error Handling if the user is not found
            email = "No user found"
        }
    }
    
    // MARK: - Delete Account Function
    // Delete account in the Firebase Auth
    private func deleteAccount() {
        // Error Hanlding to check the current logged in user
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No user found"
            showError = true
            return
        }
        
        user.delete { error in
            if let error = error {
                // Error Handling if delete account is failed
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
    
    // MARK: - Reset Password Function
    // Sending the reset password link through the user email
    private func resetPassword() {
        // Error Handling if there is no email
        guard let email = email else {
            errorMessage = "No email associated with the account"
            showError = true
            return
        }
        
        // Reset password function from Firebase Auth
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            // Error Handling if it is failed to reset password
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

// MARK: - Previews
#Preview {
    ProfileView()
}
