//
//  ErrorView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim on 20/10/2024.
//


import SwiftUI

// MARK: - Error View
struct ErrorView: View {

    // Binding Properties of ErrorView
    @Binding var alert : Bool
    @Binding var error : String
    @StateObject private var profileVM = ProfileViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Background colour
            Color.black.opacity(0.35)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    // MARK: - Display the error message header
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                // MARK: - Display the error message
                Text(self.error == "RESET" ? "Password reset link has been sent successfully to your email" : self.error)
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                // MARK: - Button for the alert with OK or Cancel option
                Button {
                    self.alert.toggle()
                } label: {
                    Text(self.error == "RESET" ? "OK": "Cancel")
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                //  INNER SHADOW (for Button)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0) // Shape of the background
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.button) // Adjust your color here
                            .frame(height: 65) // Set the height
                            .padding(.horizontal, -15) // Horizontal padding to extend the shadow area
                            .overlay(
                                RoundedRectangle(cornerRadius: 10) // Shape for the shadow effect
                                    .stroke(Color.gray, lineWidth: 6) // Shadow border color and width
                                    .blur(radius: 3) // Blur for a soft shadow
                                    .offset(x: 2, y: 6.5) // Offset to simulate depth
                                    .mask(
                                        RoundedRectangle(cornerRadius: 10) // Mask with the same shape
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom) // Gradient for inner shadow effect
                                            )
                                    )
                                    .padding(.horizontal, -15)
                            )
                    }
                )
                .clipShape(Capsule()) // Clip it to the shape of a capsule if desired
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
                
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(profileVM.isDarkMode ? .black : .white)
            .cornerRadius(15)
            .shadow(radius:10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Previews
#Preview {
    ErrorView(alert: .constant(true), error: .constant("Password is not matched"))
}

