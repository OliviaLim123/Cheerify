//
//  HomeView.swift
//  Cheerify
//
//  Created by Olivia Gita Amanda Lim 23/10/2024.
//

import SwiftUI

// I haven't linked this to any views
struct HomeView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            //  BGM
            AppColors.gradientBGM_bottomShadow
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                // Greeting Text
                VStack(alignment: .leading) {
                    Text("Hi There!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Text("Welcome back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .opacity(0.5)
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                
                // Mood Track Header
                HStack {
                    Label("Mood track", systemImage: "calendar")
                        .font(.title2)
                    Spacer()
                    Button {
                        // Will navigate to the history view?
                    } label: {
                        HStack {
                            Text("View All")
                                .foregroundStyle(.black)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                
                Spacer()

                // Calendar
                CalendarWrapper()
                    .background(.lightBeige)
                    .cornerRadius(10)
                    .frame(maxWidth: UIScreen.main.bounds.width - 50)
                    .frame(height: 300)
                Spacer()


                // Mood Status
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "deskclock.fill")
                        Text(selectedDate, style: .date)
                            .font(.headline)
                    }
                    .padding(.horizontal, 10)

                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .padding(.horizontal)
                        Text("Oops! We haven’t captured your mood today!")
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .background(.lightBeige)
                    .cornerRadius(12)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 50)
                .padding(.bottom, 5)

                // Capture Button
                Button {
                    // Action to capture the photo? ask the user permission?
                } label: {
                    Text("Capture Now!")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.button)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.horizontal)

                Spacer()
                Spacer()
            }
        }
    }
}

struct CalendarWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.backgroundColor = .clear
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Handle any updates if needed
    }
}

#Preview {
    HomeView()
}
