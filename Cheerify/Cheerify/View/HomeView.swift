import SwiftUI

// MARK: - Home View Struct
struct HomeView: View {
    
    // View model for classification
    @StateObject var viewModel = MoodViewModel()
    // View model for enable dark mode
    @StateObject private var profileVM = ProfileViewModel()
    // State to show camera
    @State private var showImagePicker = false
    // Holds the captured image
    @State private var image: UIImage? = nil
    // To navigate to ResultView
    @State private var showResultView = false
    // Calendar date selection
    @State private var selectedDate = Date()
    @State private var calendarView: UICalendarView?
    @State private var moodRecordForSelectedDate: MoodRecord?
    
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
                
                VStack(spacing: 20) {
                    // MARK: - Greeting Text
                    VStack(alignment: .leading, spacing: 8) {
                        Text("👋 There!")
                            .font(.custom("MontserratAlternates-Semibold", size: 35))
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black.opacity(0.8))
                        
                        Text("Welcome back!")
                            .font(.custom("MontserratAlternates-Semibold", size: 25))
                            .fontWeight(.bold)
                            .foregroundStyle(profileVM.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.5))
                    }
                    .tracking(1.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                    .padding(.top, 50)
                    
                    // MARK: - Mood Track Header
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 25))
                        
                        Text("Mood track")
                            .font(.custom("MontserratAlternates-Semibold", size: 20))
                    }
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black.opacity(0.8))
                    .offset(x: -100)
                    .padding(.bottom, 0)
                    
                    //                    Label("Mood track", systemImage: "calendar")
                    //                        .font(.title2)
                    //                        .font(.custom("FiraMono-Medium", size: 20))
                    //                        .foregroundStyle(profileVM.isDarkMode ? .white : .black.opacity(0.8))
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                        .padding(.horizontal, 25)
                    //                        .padding(.bottom, 0)
                    
                    // MARK: - Display Calendar
                    CalendarWrapper(selectedDate: $selectedDate)
                        .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .frame(height: 340)
                    
                    
                    // MARK: - Mood Status or Captured Image
                    if let image = image {
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .cornerRadius(15)
                                .padding()
                            
                            Button("Classify Mood") {
                                viewModel.selectedImage = image
                                viewModel.classify()
                                // Triggers the navigation to ResultView
                                showResultView = true
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    } else {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "deskclock.fill")
                                    .font(.system(size: 25))
                                
                                Text(selectedDate, style: .date)
                                //  .font(.custom("FiraMono-Medium", size: 18))
                                    .font(.custom("MontserratAlternates-Semibold", size: 18))
                                
                            }
                            .tracking(2.0)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black.opacity(0.8))
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                            
                            if let record = moodRecordForSelectedDate {
                                HStack {
                                    Image(record.imageName ?? "")
                                        .resizable()
                                        .frame(width: 85, height: 85)
                                    
                                    VStack(spacing: 18) {
                                        Text(record.imageName ?? "")
                                            .font(.custom("MontserratAlternates-Semibold", size: 15))
                                            .frame(maxWidth: .infinity)
                                            .bold()
                                            .padding(8)
                                            .background(.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    
                                        Text(record.note ?? "")
                                            .font(.custom("MontserratAlternates-Semibold", size: 13))
                                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                            .multilineTextAlignment(.center)
                                        // Allows the text to wrap across multiple lines
                                            .lineLimit(10)
                                    }
                                }
                                .padding(5)
                                .padding()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                                .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                                .cornerRadius(12)
                                
                            } else {
                                // MARK: - Placeholder
                                HStack {
                                    Image(systemName: "doc.text.magnifyingglass")
                                        .font(.largeTitle)
                                        .padding(.horizontal)
                                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                    Text("Oops! We haven’t captured your mood today!")
                                        .font(.custom("MontserratAlternates-Medium", size: 15))
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                                .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .onAppear {
                            fetchMoodForSelectedDate()
                        }
                        .onChange(of: selectedDate) {
                            // Fetch the mood record for the newly selected date
                            fetchMoodForSelectedDate()
                        }
                    }
                    
                    // MARK: - Capture Button
                    Button {
                        // Show camera to capture photo
                        showImagePicker = true
                    } label: {
                        Text("Capture Now !")
                            .font(.custom("MontserratAlternates-Bold", size: 18))
                        //  .font(.custom("FiraMono-Bold", size: 18))
                        
                            .tracking(1.5)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.button)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .sheet(isPresented: $showImagePicker) {
                    // Pass MoodViewModel to CameraView
                    CameraView(viewModel: viewModel)
                }
            }
        }
    }
    
    // MARK: - Fetch Mood for Selected Date Function
    // Fetch the mood based on the date from Core Data
    private func fetchMoodForSelectedDate() {
        moodRecordForSelectedDate = PersistenceController.shared.fetchMood(for: selectedDate)
    }
    
}

// MARK: - Calendar Wrapper
// Handle the Calender View
struct CalendarWrapper: UIViewRepresentable {
    
    @Binding var selectedDate: Date
    @StateObject var profileVM = ProfileViewModel()
    
    // MARK: - Make UI View
    // Handle how the UI view looks like
    func makeUIView(context: Context) -> UICalendarView {
        // Create the UI Calendar View
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        // Change the circle colour for the selected date
        calendarView.tintColor = .customOrange
        
        // Apply the custom font to all labels within the calendar view
        applyCustomFont(calendarView: calendarView)
        
        // Adjusting the size of the calendar
        NSLayoutConstraint.activate([
            calendarView.heightAnchor.constraint(equalToConstant: 340),
            calendarView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        return calendarView
    }
    
    // MARK: - Update UI View
    // Updating the view directly when the dark mode is enable
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if profileVM.isDarkMode {
            updateCalendarTextColor(calendarView: uiView)
        } else {
            normalCalendarTextColor(calendarView: uiView)
        }
        // Reapply the custom font in case the view needs updating
        applyCustomFont(calendarView: uiView)
    }
    
    // MARK: - Apply Custom Font
    // Apply the custom font to all UILabels within UICalendarView.
    func applyCustomFont(calendarView: UICalendarView) {
        // Iterate through subviews to locate UILabels and apply the custom font
        for subview in calendarView.subviews {
            for view in subview.subviews {
                if let label = view as? UILabel {
                    // Setting the custom font "MontserratAlternates-Semibold"
                    label.font = UIFont(name: "MontserratAlternates-Semibold", size: 19)
                }
            }
        }
    }
    
    // MARK: - Normal Calendar Color
    // Manage how the calendar looks like when light mode
    func normalCalendarTextColor(calendarView: UICalendarView) {
        for subview in calendarView.subviews {
            for view in subview.subviews {
                if let label = view as? UILabel {
                    label.textColor =  .brown
                }
            }
        }
    }
    
    // MARK: - Update Calendar Color
    // Manage how the calendar looks like when dark mode enabled
    func updateCalendarTextColor(calendarView: UICalendarView) {
        for subview in calendarView.subviews {
            for view in subview.subviews {
                if let label = view as? UILabel {
                    label.textColor = profileVM.isDarkMode ? .white : .black
                }
            }
        }
    }
    
    // MARK: - Make Coordinator Function
    // Create the Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator Class
    // Acts as the delegate and handles interactions with UICalendarView and date selection.
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        var parent: CalendarWrapper
        
        // Initialiser
        init(_ parent: CalendarWrapper) {
            self.parent = parent
        }
        
        // MARK: - Date Selection Function
        // Called when the user selects the specified date
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}

// MARK: - Previews
#Preview {
    HomeView()
}
