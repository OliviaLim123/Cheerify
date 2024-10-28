//
//  LoginView.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//

import SwiftUI
import FirebaseAuth

// MARK: - Login View Struct
// Handle the user's authentication to the application
struct LoginView: View {
    
    // State properties
    @State var email: String = ""
    @State var password: String = ""
    @State var visible: Bool = false
    @State var navigateToSignUp: Bool = false
    @State var navigateToHome: Bool = false
    @State var alert: Bool = false
    @State var error: String = ""
    @StateObject private var profileVM = ProfileViewModel()
    
    // MARK: - Body
    var body: some View {
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
                // MARK: -Display the application logo
                HStack {
                    Text("Welcome Cheerier!")
                        .font(.custom("MontserratAlternates-Medium", size: 40))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    
                        .padding(.horizontal)
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                }
                .padding(.bottom, 60)
                
                VStack(alignment: .leading) {
                    // MARK: - Display the email text field
                    Text("Email Address")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke( self.email != "" ? .customOrange : Color.black, lineWidth: 2))
                        .padding(.bottom, 20)
                    
                    // MARK: - Display the password text field
                    Text("Password")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    HStack(spacing: 15) {
                        if self.visible {
                            // If it is visible, display the normal text field
                            TextField("Password", text: self.$password)
                                .autocapitalization(.none)
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        } else {
                            // If it is invisible, display the secure text field
                            SecureField("Password", text: self.$password)
                                .autocapitalization(.none)
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        }
                        // MARK: - Eye button to see the password
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke( self.password != "" ? .customOrange : Color.black, lineWidth: 2))
                }
                
                HStack {
                    Spacer()
                    // MARK: - Button to reset the password
                    Button {
                        self.reset()
                    } label: {
                        Text("Forget password")
                            .fontWeight(.bold)
                            .foregroundStyle(.customOrange)
                    }
                    .padding(.top, 20)
                }
                
                // MARK: - Button to log in and it will verify the user credentials
                Button {
                    self.verify()
                } label :{
                    Text("Log in")
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(.button)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .padding(.top, 25)
                // This button will navigate to the TabView
                .navigationDestination(isPresented: $navigateToHome) {
                    TabBar()
                        .navigationBarBackButtonHidden(true)
                }
                
                // MARK: - Button to register the new user
                Button {
                        self.navigateToSignUp = true
                } label: {
                    HStack {
                        Text("Not registered yet? ")
                            .fontWeight(.bold)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        Text("Create an account")
                            .fontWeight(.bold)
                            .foregroundStyle(.customOrange)
                    }
                }
                .padding()
                // This button will navigate to the SignUpView
                .navigationDestination(isPresented: $navigateToSignUp) {
                    SignUpView()
                }
                
            }
            .padding(.horizontal, 25)
            
            // Error Handling by displaying the alert about the error
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    // MARK: - Verify Function
    // Function to very the user email and password
    func verify() {
        if self.email != "" && self.password != "" {
            // Sign in function from the Firebase Auth
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                // Error Handling
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.navigateToHome = true
                // Debug
                print("success")
                // Save the user status after log in
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            // Error Handling
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    // MARK: Reset Password Function
    // Function to reset user password
    func reset() {
        if self.email != "" {
            // Reset password function from Firebase Auth
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                // Error Handling
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
        } else {
            // ERROR HANDLING
            self.error = "Email ID is empty"
            self.alert.toggle()
        }
    }
}

// MARK: - Previews
#Preview {
    LoginView()
}
