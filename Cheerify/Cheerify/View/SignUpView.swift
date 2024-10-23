//
//  SignUpView.swift
//  Cheerify
//
//  Created by Hang Vu on 19/10/2024.
//

import SwiftUI
import FirebaseAuth

// MARK: SIGN UP VIEW
struct SignUpView: View {
    
    // STATE PROPERTIES of SignUpView
    @State var email: String = ""
    @State var password: String = ""
    @State var repassword: String = ""
    @State var visible: Bool = false
    @State var revisible: Bool = false
    @State var alert: Bool = false
    @State var error: String = ""
    @State var navigateToLogin: Bool = false
    
    // BODY VIEW
    var body: some View {
        ZStack {
            
            //  BGM
            AppColors.gradientBGM_topShadow
                .ignoresSafeArea(.all)
            
            VStack {
                // Display application logo
                HStack {
                    Text("Create Your Account!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
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
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke( self.email != "" ? .customOrange : Color.black, lineWidth: 2))
                        .padding(.bottom, 20)
                    
                    // Display the password text field
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
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke( self.password != "" ? .customOrange : Color.black, lineWidth: 2))
                    
                    // Display the confirm password text field
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
                        
                        // Button to see or hide the confirm password
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
                
                
                
                // Button to register the new user
                Button {
                    self.register()
                } label :{
                    Text("Register")
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(.button)
                .cornerRadius(20)
                .padding(.top, 25)
                // This button will navigate to the LoginView
                .navigationDestination(isPresented: $navigateToLogin) {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.horizontal, 25)
            
            // ERROR HANDLING to display the error message
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    // FUNCTION to register the new user email and password
    func register() {
        if self.email != "" {
            if self.password == self.repassword {
                // Create user function from Firebase Auth
                Auth.auth().createUser(withEmail: self.email, password: self.password) { (res, err) in
                    // ERROR HANDLING
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    self.navigateToLogin = true
                    // DEBUG
                    print("success")
                    // Save the status after successfully register
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            } else {
                // ERROR HANDLING if the password mismatch
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        } else {
            // ERROR HANDLING
            self.error = "Please fill all the credentials properly"
            self.alert.toggle()
        }
    }
}

// MARK: SIGN UP PREVIEW
#Preview {
    SignUpView()
}
