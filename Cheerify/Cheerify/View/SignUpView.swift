//
//  SignUpView.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//

import SwiftUI
import FirebaseAuth

// MARK: - Sign Up View
struct SignUpView: View {
    
    // State properties of SignUpView
    @State var email: String = ""
    @State var password: String = ""
    @State var repassword: String = ""
    @State var visible: Bool = false
    @State var revisible: Bool = false
    @State var alert: Bool = false
    @State var error: String = ""
    @State var navigateToLogin: Bool = false
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
                // MARK: - Display application logo
                HStack {
                    Text("Sign Up !")
                        .font(.custom("MontserratAlternates-Medium", size: 40))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
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
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke( self.email != "" ? .customOrange : Color.black, lineWidth: 2))
                        .padding(.bottom, 20)
                    
                    // MARK: - Display the password text field
                    Text("Password")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 15) {
                        if self.visible {
                            // If it is visible, display the normal text field
                            TextField("Password", text: self.$password)
                                .autocapitalization(.none)
                        } else {
                            // If it is invisible, display the secure text field
                            SecureField("Password", text: self.$password)
                                .autocapitalization(.none)
                        }
                        
                        // MARK: - Eye icon to see the password
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke( self.password != "" ? .customOrange : Color.black, lineWidth: 2))
                    
                    // MARK: - Display the confirm password text field
                    Text("Confirm Password")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 20)
                    HStack(spacing: 15) {
                        // If it is visible, display the normal text field
                        if self.revisible {
                            TextField("Confirm Password", text: self.$repassword)
                                .autocapitalization(.none)
                        } else {
                            // If it is invisible, display the secure text field
                            SecureField("Confirm Password", text: self.$repassword)
                                .autocapitalization(.none)
                        }
                        
                        // MARK: - Button to see or hide the confirm password
                        Button {
                            self.revisible.toggle()
                        } label: {
                            Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke( self.password != "" ? .customOrange : Color.black, lineWidth: 2))
                }
                
                
                
                // MARK: - Button to register the new user
                Button {
                    self.register()
                } label :{
                    Text("Create Account")
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(.button)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .padding(.top, 25)
                // This button will navigate to the LoginView
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.horizontal, 25)
            
            // Error Handling to display the error message
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    // MARK: - Register User Function
    // Function to register the new user email and password to the Firebase
    func register() {
        if self.email != "" {
            if self.password == self.repassword {
                // Create user function from Firebase Auth
                Auth.auth().createUser(withEmail: self.email, password: self.password) { (res, err) in
                    // Error handling
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    self.navigateToLogin = true
                    // Debug
                    print("success")
                    // Save the status after successfully register
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            } else {
                // Error Handling if the password mismatch
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        } else {
            // Error Handling
            self.error = "Please fill all the credentials properly"
            self.alert.toggle()
        }
    }
}

// MARK: - Previews
#Preview {
    SignUpView()
}
