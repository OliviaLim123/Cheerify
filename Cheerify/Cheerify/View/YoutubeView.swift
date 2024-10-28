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
    @State private var searchQuery: String = "" // Start with an empty search query & Track user-entered search query
    @State private var activeTopics: [String] = [] // Tracks current search or mood topics to display
    let defaultTopics: [String] // Mood-based default topics to randomize
    
    var body: some View {
        ZStack {
            // Background gradient fills the entire screen
            //AppColors.gradientBGM_bottomShadow
                //.ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                // Gradient header with bold style
                Text("YouTube Video Search")
//                    .font(.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        AppColors.sunsetGradient
                    )
                    .cornerRadius(15)
                    .padding(.horizontal)
                //  Shadowing
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                // Search bar with custom styling
                HStack {
                    TextField("Search videos...", text: $searchQuery)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.5), radius: 3, x: 1, y: 1)
                    
                    Button(action: {
                        // If searchQuery is empty, use 5 random topics from default mood-based topics
                        if searchQuery.isEmpty {
                            activeTopics = Array(defaultTopics.shuffled().prefix(5))
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
                
                // Horizontal ScrollView for video previews based on active search or default topics
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(activeTopics, id: \.self) { topic in
                            YouTubeSearchViewRepresentable(searchQuery: topic)
                                .frame(width: 300, height: 400)
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
        .onAppear {
            // Set initial topics to mood-based topics when view appears
            //            activeTopics = defaultTopics
            // Load 5 random topics from default mood-based list when view appears
            activeTopics = Array(defaultTopics.shuffled().prefix(5))
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(defaultTopics: [
            "happy vibe playlist", "productive daily vlogs", "funny animal videos",
            "motivational talks", "relaxing jazz music", "light up mood workout",
            "travel adventure videos", "cute puppies and kittens"
        ])
    }
}
