import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoodViewModel
    @StateObject private var profileVM = ProfileViewModel()
    @State private var isSaved = false
    
    var body: some View {
           ZStack {
               // Background gradient based on dark mode preference
               if profileVM.isDarkMode {
                   AppColors.darkGradientBGM_bottomShadow
                       .ignoresSafeArea(.all) // Extend gradient to the edges for a smooth background
               } else {
                   AppColors.gradientBGM_bottomShadow
                       .ignoresSafeArea(.all) // Extend gradient to the edges for a smooth background
               }

               // Scrollable content view
               ScrollView {
                   VStack(spacing: 25) {
                       
                       // MARK: - Title displaying user's mood
                       Text("Your Mood Today!")
                           .font(.largeTitle) // Large title for emphasis
                           .fontWeight(.bold) // Bold to grab attention
                           .foregroundColor(profileVM.isDarkMode ? .white : .black) // Dynamic color based on theme
                           .padding(.top, 40) // Extra padding at the top for breathing room
                       
                       // MARK: - Mood Image
                       Image(moodImageName())
                           .resizable() // Make image resizable to fit dimensions
                           .scaledToFit() // Maintain aspect ratio while fitting
                           .frame(width: 180, height: 180) // Set specific frame size
                           .padding(.bottom, 10) // Bottom padding to separate from text
                       
                       // MARK: - Mood-based note description
                       Text(moodNote())
                           .font(.title3) // Smaller font for mood description
                           .multilineTextAlignment(.center) // Center align for readability
                           .foregroundColor(profileVM.isDarkMode ? .white : .black) // Theme-based color
                           .padding(.horizontal, 30) // Horizontal padding for balanced spacing
                       
                       // MARK: - Classification Details (Model Prediction Result)
                       Text(viewModel.resultText)
                           .font(.headline) // Headline font for importance
                           .foregroundColor(profileVM.isDarkMode ? .white : .black) // Theme-based color
                           .padding(.horizontal, 30) // Padding for nice alignment
                           .padding(.top, 5) // Light top padding for separation
                           .background(
                               RoundedRectangle(cornerRadius: 10)
                                   .fill(Color.black.opacity(0.05)) // Background with slight opacity for focus
                           )
                                            
                       // MARK: - VideoView for Mood-based Recommendations
                       VideoView(defaultTopics: videoTopicsForMood())
                       
                       // MARK: - Save Mood Button
                       Button(action: {
                           saveMoodResult() // Save mood action
                           isSaved = true // Update state to reflect saved mood
                       }) {
                           Text(isSaved ? "Mood Saved!" : "Save Mood") // Dynamic button text based on save state
                               .fontWeight(.semibold) // Bold text to make the button stand out
                               .padding() // Padding inside the button for touch area
                               .frame(maxWidth: .infinity) // Full-width button for alignment
                               .background(isSaved ? Color.gray : Color.customOrange) // Dynamic background color based on save state
                               .foregroundColor(.white) // White text for readability
                               .cornerRadius(15) // Rounded corners for a smooth, modern look
                               .shadow(radius: 4) // Light shadow for slight pop effect
                       }
                       .padding(.horizontal, 16) // Extra padding for centering button
                       .padding(.bottom, 30) // Bottom padding for spacing at end of content
                   }
                   .padding() // General padding for VStack
               }
           }
       }


    // MARK: - Mood Image Function
    // Function to get image name based on the predicted mood
    private func moodImageName() -> String {
        switch viewModel.predictedMood {
        case "happy":
            return "happyOctopus"
        case "fear":
            return "fearCow"
        case "angry":
            return "MadRoboo"
        case "neutral":
            return "neutralHuman"
        case "sad":
            return "sadApple"
        default:
            return "happyOctopus" // Default image if no mood is detected
        }
    }

    // MARK: - Mood Note Function
    // Function to get a mood-based note for the user
    private func moodNote() -> String {
        switch viewModel.predictedMood {
        case "happy":
            return "We have a happy octopus here ♥️"
        case "fear":
            return "What’s making your heart race right now?"
        case "angry":
            return "Seems like everything’s been pushing your limits todayyy"
        case "neutral":
            return "Today seems to have its ups and downs for you 🫂"
        case "sad":
            return "aww, why you are a sad apple today ?"
        default:
            return "We have a happy octopus here ♥️" // Default note if no mood is detected
        }
    }

    //  MARK: Uncomment this one to see the Preview
    // Function to get mood-based topics for YouTube recommendations
//        private func videoTopicsForMood() -> [String] {
//            switch viewModel.predictedMood {
//            case "happy":
//                return ["happy vibe playlist", "productive daily vlogs", "funny animal videos", "motivational talks", "relaxing jazz music"]
//            case "fear":
//                return ["calm mind meditation", "overcoming fears", "stress relief exercises", "mindfulness practice", "relaxing nature sounds"]
//            case "angry":
//                return ["anger management tips", "relaxing yoga", "breathing exercises", "calm down techniques", "motivational talks"]
//            case "neutral":
//                return ["relaxing music", "calm nature sounds", "soothing piano music", "ambient background", "neutral mood playlist"]
//            case "sad":
//                return ["uplifting music", "inspiring talks", "funny animal videos", "relaxing jazz", "happy moments compilation"]
//            default:
//                return ["happy vibe playlist", "motivational talks", "funny animal videos", "relaxing music", "positive energy playlist"]
//            }
//        }
    
    // MARK: COMMENT this one AND CHANGE IT TO THE CODE ABOVE TO SEE THE REVIEW - LEONIE
    // MARK: - Video Topics for Mood
    // Function to get mood-based topics for YouTube recommendations
    private func videoTopicsForMood() -> [String] {
        // MARK: - Mood-based Video Topics Dictionary
        // Dictionary of recommended video topics tailored to each mood
        let moodTopics: [String: [String]] = [
            "happy": [
                "happy vibe playlist", "productive daily vlogs", "funny animal videos",
                "motivational talks", "relaxing jazz music", "light up mood workout",
                "travel adventure videos", "cute puppies and kittens", "uplifting songs", "comedy sketches"
            ],
            "fear": [
                "calm mind meditation", "overcoming fears", "stress relief exercises",
                "mindfulness practice", "relaxing nature sounds", "guided deep breathing",
                "soothing forest walks", "calm ocean waves", "comforting ASMR", "meditative focus"
            ],
            "angry": [
                "anger management tips", "relaxing yoga", "breathing exercises",
                "calm down techniques", "motivational talks", "peaceful scenery", "guided relaxation",
                "mood lifting speeches", "positive affirmations", "stress reduction techniques"
            ],
            "neutral": [
                "relaxing music", "calm nature sounds", "soothing piano music",
                "ambient background", "neutral mood playlist", "serene ocean waves",
                "minimalist vlogs", "quiet library ambiance", "forest rain sounds", "evening chill beats"
            ],
            "sad": [
                "uplifting music", "inspiring talks", "funny animal videos",
                "relaxing jazz", "happy moments compilation", "hopeful stories",
                "self-care routines", "heartwarming scenes", "positive journaling", "laugh therapy"
            ]
        ]

        // MARK: - Default Video Topics
        // Fallback video topics in case the mood is not found in the dictionary
        let defaultTopics = [
            "happy vibe playlist", "motivational talks", "funny animal videos",
            "relaxing music", "positive energy playlist", "serene nature scenes",
            "feel good videos", "comforting soundscapes", "morning inspiration", "peaceful views"
        ]

        // Fetch the list of topics based on the predicted mood or use default topics if mood isn't found
        let topics = moodTopics[viewModel.predictedMood] ?? defaultTopics

        // MARK: - Randomized Topic Selection
        // Returns a randomized selection of up to 5 topics for variety
        return getRandomTopics(from: topics, count: 5)
    }

    // MARK: - Random Topics Helper Function
    // Helper function that shuffles the provided topics and returns a specified number of items
    private func getRandomTopics(from topics: [String], count: Int) -> [String] {
        return Array(topics.shuffled().prefix(count))
    }

    // MARK: - Save Mood Result Function
    // Function to save the current mood data, including mood, note, and image
    private func saveMoodResult() {
        let mood = viewModel.predictedMood
        let note = moodNote()
        let imageName = moodImageName()
        let date = Date()
        
        // Use persistence controller to save the mood details
        PersistenceController.shared.saveMood(mood: mood, note: note, imageName: imageName, date: date)
    }
}

// MARK: - Previews
#Preview {
    ResultView(viewModel: MoodViewModel())
}
