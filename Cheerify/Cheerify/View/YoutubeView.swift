import SwiftUI
import WebKit

// This struct is for embedding YouTube search results
struct YouTubeSearchViewRepresentable: UIViewRepresentable {
    let searchQuery: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Construct the search URL for YouTube
        let searchURLString = "https://www.youtube.com/results?search_query=\(searchQuery)"
        guard let url = URL(string: searchURLString) else { return }
        
        uiView.load(URLRequest(url: url))
    }
}

// The main view that shows the YouTube search content
struct VideoView: View {
    @State private var searchQuery: String = "good vibe playlist" // Start with an empty search query
    @State private var activeTopics: [String] = []
    
    // Predefined list of happy mood topics
    private let happyMoodTopics = [
        "happy vibe playlist",
        "productive daily vlogs",
        "cook vlogs",
        "light up mood workout",
        "DIY home decor",
        "funny animal videos",
        "relaxing jazz music",
        "motivational talks",
        "travel adventure videos",
        "cute puppies and kittens"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient fills the entire screen
                AppColors.gradientBGM_bottomShadow
                    .ignoresSafeArea(.all)

                VStack(spacing: 20) {
                    // Gradient header with bold style
                    Text("YouTube Video Search")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.yellow, Color.orange.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    // Search bar with custom styling
                    HStack {
                        TextField("Search videos...", text: $searchQuery)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 1)
                        
                        Button(action: {
                            // Randomly pick 5 topics from happyMoodTopics if searchQuery is empty
                            if searchQuery.isEmpty {
                                activeTopics = Array(happyMoodTopics.shuffled().prefix(5))
                            } else {
                                activeTopics = [searchQuery]
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 24)
                                .background(Color.orange)
                                .cornerRadius(12)
                                .shadow(color: .orange.opacity(0.6), radius: 5, x: 2, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Horizontal ScrollView for video previews based on active search
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            // Display each video view with unique search query
                            ForEach(activeTopics, id: \.self) { topic in
                                YouTubeSearchViewRepresentable(searchQuery: topic)
                                    .frame(width: 300, height: 400) // Adjust width and height as needed
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(15)
                                    .shadow(color: .gray.opacity(0.7), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.top) // Padding at the top to keep it visually aligned
            }
            .navigationBarHidden(true) // Hides navigation bar space
        }
        .onAppear {
            // Set an initial 5 random topics
            activeTopics = Array(happyMoodTopics.shuffled().prefix(5))
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
