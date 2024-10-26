//
//   MoodTrackingView.swift
//  Cheerify
//
//  Created by Hang Vu on 22/10/2024.
//

import SwiftUI

struct MoodTrackingView: View {
    @State private var moods: [MoodRecord] = [] // Store fetched moods
    @State private var selectedDate = Date()     // Track selected date
    @StateObject var profileVM = ProfileViewModel()
    private let persistenceController = PersistenceController.shared

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
                // Title
                VStack(alignment: .leading) {
                    Text("Your Mood")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    HStack {
                        Text("History")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            .opacity(0.5)
                        Image(systemName: "puzzlepiece")
                            .font(.largeTitle)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                
                if moods.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 80))
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .black)
                            .padding(.bottom, 10)
                        
                        Text("Sorry, no history found!")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .black)
                        
                        Text("Please track your first mood to see it here!")
                            .font(.headline)
                            .foregroundStyle(profileVM.isDarkMode ? .lightBeige.opacity(0.5) : .black.opacity(0.5))
                            .padding(.top, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(moods, id: \.id) { mood in
                                MoodRow(mood: mood) {
                                    deleteMood(mood) // Call delete function when delete is confirmed
                                }
                            }
                        }
                        .padding() // Add padding around the VStack
                    }
                }
            }
            .onAppear {
                fetchMoodsForSelectedDate() // Fetch initial moods when the view appears
            }
        }
    }

    // Fetch moods for the selected date
    private func fetchMoodsForSelectedDate() {
        moods = persistenceController.fetchMood(for: selectedDate).map { [$0] } ?? []
    }
    
    // Delete mood from Core Data and update the UI
    private func deleteMood(_ mood: MoodRecord) {
        persistenceController.deleteMood(mood)
        fetchMoodsForSelectedDate() // Refresh the mood list
    }
}

// Row View with Delete Button
struct MoodRow: View {
    let mood: MoodRecord
    let onDelete: () -> Void
    @StateObject var profileVM = ProfileViewModel()

    var body: some View {
        HStack {
            if let imageName = mood.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            VStack(alignment: .leading) {
                Text(mood.imageName ?? "")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(2)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(20)

                if let note = mood.note {
                    Text(note)
                        .font(.subheadline)
                }
                Text(mood.date?.formatted() ?? "")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(profileVM.isDarkMode ? .lightBeige : .darkBeige)
            }
            Spacer()
            // Delete Button
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


#Preview {
    MoodTrackingView()
}
