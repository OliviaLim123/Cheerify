import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = MoodViewModel()  // View model for classification
    @State private var showImagePicker = false   // State to show camera
    @State private var image: UIImage? = nil     // Holds the captured image
    @State private var showResultView = false    // To navigate to ResultView
    @State private var selectedDate = Date()     // Calendar date selection
    
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
                        // Action to navigate to history view (optional)
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
                .padding(.horizontal)
                
                Spacer()
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                CameraView()
            }
            
            // Navigation to ResultView when mood is classified
            NavigationLink(destination: ResultView(viewModel: viewModel), isActive: $showResultView) {
                EmptyView() // Hidden link that activates on classification
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
