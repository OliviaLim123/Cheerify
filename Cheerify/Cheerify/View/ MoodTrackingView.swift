//
//   MoodTrackingView.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI

// MARK: - Mood Tracking View Struct
// Handle the user's mood history
struct MoodTrackingView: View {
    
    // Store fetched moods
    @State private var moods: [MoodRecord] = []
    // Track selected date
    @State private var selectedDate = Date()
    // State Object for track the darkmode
    @StateObject var profileVM = ProfileViewModel()
    private let persistenceController = PersistenceController.shared
    
    // MARK: - BODY
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
                // MARK: - Title
                VStack(alignment: .leading) {
                    Text("Your Mood")
                        .font(.custom("FiraMono-Medium", size: 40))
                        .fontWeight(.bold)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    HStack {
                        Text("History")
                            .font(.custom("FiraMono-Medium", size: 30))
                            .fontWeight(.bold)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            .opacity(0.5)
                        Image(systemName: "puzzlepiece")
                            .font(.largeTitle)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                
                // MARK: - Mood History View
                // Display placeholder when there is no mood history record
                if moods.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 80))
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .black)
                            .padding(.bottom, 10)
                        
                        Text("Sorry, no history found!")
                            .font(.custom("FiraMono-Medium", size: 25))
                            .multilineTextAlignment(.center)
                            .fontWeight(.semibold)
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .black)
                        
                        Text("Please track your first mood to see it here!")
                            .font(.title3)
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige.opacity(0.5) : .black.opacity(0.5))
                            .padding(.top, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Display the all mood records
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(moods, id: \.id) { mood in
                                MoodRow(mood: mood) {
                                    // Call delete function when delete is confirmed
                                    deleteMood(mood)
                                }
                            }
                        }
                        // Add padding around the VStack
                        .padding()
                    }
                }
            }
            .onAppear {
                fetchAllMoods()
            }
        }
    }

    // MARK: Fetch All Moods Function
    // Fetch all moods record from the Core Data
    private func fetchAllMoods() {
        moods = persistenceController.fetchMoods()
    }
    
    // MARK: Delete Mood Function
    // Delete mood from Core Data and update the UI
    private func deleteMood(_ mood: MoodRecord) {
        persistenceController.deleteMood(mood)
        // Refresh the mood list
        fetchAllMoods()
    }
}

// MARK: - Mood Row Struct
// Row View with Delete Button
struct MoodRow: View {
    
    // Properties of Mood Row
    let mood: MoodRecord
    let onDelete: () -> Void
    @StateObject var profileVM = ProfileViewModel()

    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Display Image
            if let imageName = mood.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                // Show the placeholder if there is no imageName
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading) {
                // MARK: - Display ImageName
                Text(mood.imageName ?? "")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(2)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                // MARK: - Display Mood Note
                if let note = mood.note {
                    Text(note)
                        .font(.subheadline)
                }
                // MARK: - Display Mood Date
                Text(mood.date?.formatted() ?? "")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .darkBeige)
            }
            Spacer()
            
            // MARK: - Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .red)
                    .padding()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
        .cornerRadius(12)
    }
}

// MARK: - Previews
#Preview {
    MoodTrackingView()
}
