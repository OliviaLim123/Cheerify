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
                    VStack(alignment: .leading) {
                        Text("Hi There!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        Text("Welcome back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            .opacity(0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                    
                    // MARK: - Mood Track Header
                    HStack {
                        Label("Mood track", systemImage: "calendar")
                            .font(.title2)
                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                        Spacer()
                        NavigationLink {
                            // Action to navigate to history view (optional)
                        } label: {
                            HStack {
                                Text("View All")
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // MARK: - Display Calendar
                    CalendarWrapper(selectedDate: $selectedDate)
                        .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .frame(height: 200)
                        .padding(.bottom, 20)
                
                    Spacer()
                    
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
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                
                                Text(selectedDate, style: .date)
                                    .font(.headline)
                                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            
                            if let record = moodRecordForSelectedDate {
                                HStack {
                                    Image(record.imageName ?? "")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                    
                                    VStack {
                                        Text(record.imageName ?? "")
                                            .frame(maxWidth: .infinity)
                                            .bold()
                                            .padding(2)
                                            .background(.black)
                                            .foregroundColor(.white)
                                            .cornerRadius(20)
                                        Text(record.note ?? "")
                                            .font(.subheadline)
                                            .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                                            // Allows the text to wrap across multiple lines
                                            .lineLimit(nil)
                                    }
                                        
                                }
                                .padding()
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
                        Text("Capture Now!")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.button)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 20)
                    
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
        
        // Adjusting the size of the calendar 
        NSLayoutConstraint.activate([
            calendarView.heightAnchor.constraint(equalToConstant: 200),
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
    }

    // MARK: - Normal Calendar Color
    // Manage how the calendar looks like when light mode
    func normalCalendarTextColor(calendarView: UICalendarView) {
        for subview in calendarView.subviews {
            for view in subview.subviews {
                if let label = view as? UILabel {
                    label.textColor =  .black
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
