//
//  LoginView.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var visible: Bool = false
    @State var navigateToSignUp: Bool = false
    @State var navigateToHome: Bool = false
    @State var alert: Bool = false
    @State var error: String = ""
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
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
                // Display the application logo
                HStack {
                    Text("Welcome Cheerier!")
                        .font(.largeTitle)
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
                    // Display the email text field
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
                    
                    // Display the password text field
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
                    // Button to reset the password
                    Button {
                        self.reset()
                    } label: {
                        Text("Forget password")
                            .fontWeight(.bold)
                            .foregroundStyle(.customOrange)
                    }
                    .padding(.top, 20)
                }
                
                // Button to log in and it will verify the user credentials
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
                .padding(.top, 25)
                // This button will navigate to the TabView
                .navigationDestination(isPresented: $navigateToHome) {
                    TabBar()
                        .navigationBarBackButtonHidden(true)
                }
                // Button to register the new user
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
            
            // ERROR HANDLING by displaying the alert about the error
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    // FUNCTION to very the user email and password
    func verify() {
        if self.email != "" && self.password != "" {
            // Sign in function from the Firebase Auth
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                // ERROR HANDLING
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.navigateToHome = true
                // DEBUG
                print("success")
                // Save the user status after log in
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            // ERROR HANDLING
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    // FUNCTION to reset the password
    func reset() {
        if self.email != "" {
            // Reset password function from Firebase Auth
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                // ERROR HANDLING
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

#Preview {
    LoginView()
}
