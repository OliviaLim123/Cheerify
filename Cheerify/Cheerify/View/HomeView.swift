import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = MoodViewModel()  // View model for classification
    @State private var showImagePicker = false   // State to show camera
    @State private var image: UIImage? = nil     // Holds the captured image
    @State private var showResultView = false    // To navigate to ResultView
    @State private var selectedDate = Date()     // Calendar date selection
    @StateObject private var profileVM = ProfileViewModel()
    @State private var calendarView: UICalendarView?
    @State private var moodRecordForSelectedDate: MoodRecord?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // BGM, changing based on dark or light mode
                if profileVM.isDarkMode {
                    AppColors.darkGradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                } else {
                    AppColors.gradientBGM_bottomShadow
                        .ignoresSafeArea(.all)
                }
                
                VStack(spacing: 20) {
                    // Greeting Text
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
                    
                    // Mood Track Header
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
                    
                    // Calendar
                    CalendarWrapper(selectedDate: $selectedDate)
                        .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .frame(height: 200)
                        .padding(.bottom, 20)
                
                    Spacer()
                    
                    // Mood Status or Captured Image
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
                                showResultView = true // Triggers the navigation to ResultView
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
                                            .lineLimit(nil) // Allows the text to wrap across multiple lines
                                    }
                                        
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(profileVM.isDarkMode ? .darkBeige : .lightBeige)
                                .cornerRadius(12)
                            } else {
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
                            fetchMoodForSelectedDate()  // Fetch the mood record for the newly selected date
                        }
                    }
                    
                    // Capture Button
                    Button {
                        showImagePicker = true // Show camera to capture photo
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
                    CameraView(viewModel: viewModel) // Pass MoodViewModel to CameraView
                }
            }
        }
    }
    
    private func fetchMoodForSelectedDate() {
        moodRecordForSelectedDate = PersistenceController.shared.fetchMood(for: selectedDate)
    }
    
}

struct CalendarWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    @StateObject var profileVM = ProfileViewModel()
    
    func makeUIView(context: Context) -> UICalendarView {
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
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if profileVM.isDarkMode {
            updateCalendarTextColor(calendarView: uiView)
        } 
    }

    func updateCalendarTextColor(calendarView: UICalendarView) {
        for subview in calendarView.subviews {
            for view in subview.subviews {
                if let label = view as? UILabel {
                    label.textColor = profileVM.isDarkMode ? .white : .black
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarWrapper
        
        init(_ parent: CalendarWrapper) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
