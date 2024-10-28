import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoodViewModel
    @StateObject private var profileVM = ProfileViewModel()
    @State private var isSaved = false
    @State private var animateImage = false // Animation state for mood image
    
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
                    Text("Your Mood Today")
                        //.font(.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .tracking(2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            AppColors.sunsetGradient
                        )
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    //  Shadowing
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    // MARK: - Mood Image with Animation
                    Image(moodImageName())
                        .resizable()
                        .scaledToFit()
                        .frame(width: animateImage ? 200 : 180, height: animateImage ? 200 : 180)
                        .padding(.bottom, 10)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                animateImage.toggle()
                            }
                        }
                    
                    // MARK: - Mood-based note description
                    Text(moodNote())
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(profileVM.isDarkMode ? .white : .brown)
                        .lineSpacing(10)
                        .tracking(2.0)
                        .padding(.horizontal, 30)
//                        .background(RoundedRectangle(cornerRadius: 15)
//                            .fill(Color.white.opacity(0.15))
//                            .padding(4))
                    
                    // MARK: - Classification Details with Background
                    Text(viewModel.resultText)
                        .font(.headline)
                        .foregroundColor(profileVM.isDarkMode ? .white : .black.opacity(0.6))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .padding(.horizontal, 30)
                        .padding(.top, 5)
                    
                    // MARK: - VideoView for Mood-based Recommendations
                    VideoView(defaultTopics: videoTopicsForMood())
                    
                    // MARK: - Save Mood Button with Dynamic Feedback
                    Button(action: {
                        saveMoodResult()
                        withAnimation(.easeInOut) { isSaved.toggle() }
                    }) {
                        HStack {
                            Text(isSaved ? "Mood Saved!" : "Save Mood") // Keeps text and button unified
                                .fontWeight(.semibold)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity) // Full-width alignment
                                .background(isSaved ? Color.gray : Color.customOrange) // Original colors for dynamic effect
                                .foregroundColor(.white)
                                .cornerRadius(15) // Smooth, rounded look
                        }
                        .shadow(radius: 4) // Slight shadow for subtle depth
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
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
    
    //  MARK: Uncomment this one to see the Preview - LEONIE
    // Function to get mood-based topics for YouTube recommendations
    private func videoTopicsForMood() -> [String] {
        switch viewModel.predictedMood {
        case "happy":
            return ["happy vibe playlist", "productive daily vlogs", "funny animal videos", "motivational talks", "relaxing jazz music"]
        case "fear":
            return ["calm mind meditation", "overcoming fears", "stress relief exercises", "mindfulness practice", "relaxing nature sounds"]
        case "angry":
            return ["anger management tips", "relaxing yoga", "breathing exercises", "calm down techniques", "motivational talks"]
        case "neutral":
            return ["relaxing music", "calm nature sounds", "soothing piano music", "ambient background", "neutral mood playlist"]
        case "sad":
            return ["uplifting music", "inspiring talks", "funny animal videos", "relaxing jazz", "happy moments compilation"]
        default:
            return ["happy vibe playlist", "motivational talks", "funny animal videos", "relaxing music", "positive energy playlist"]
        }
    }
    
    // MARK: COMMENT this one AND CHANGE IT TO THE CODE ABOVE TO SEE THE PREVIEW - LEONIE
    // MARK: - Video Topics for Mood
    // Function to get mood-based topics for YouTube recommendations
    //    private func videoTopicsForMood() -> [String] {
    // MARK: - Mood-based Video Topics Dictionary
    // Dictionary of recommended video topics tailored to each mood
    //        let moodTopics: [String: [String]] = [
    //            "happy": [
    //                "happy vibe playlist", "productive daily vlogs", "funny animal videos",
    //                "motivational talks", "relaxing jazz music", "light up mood workout",
    //                "travel adventure videos", "cute puppies and kittens", "uplifting songs", "comedy sketches"
    //            ],
    //            "fear": [
    //                "calm mind meditation", "overcoming fears", "stress relief exercises",
    //                "mindfulness practice", "relaxing nature sounds", "guided deep breathing",
    //                "soothing forest walks", "calm ocean waves", "comforting ASMR", "meditative focus"
    //            ],
    //            "angry": [
    //                "anger management tips", "relaxing yoga", "breathing exercises",
    //                "calm down techniques", "motivational talks", "peaceful scenery", "guided relaxation",
    //                "mood lifting speeches", "positive affirmations", "stress reduction techniques"
    //            ],
    //            "neutral": [
    //                "relaxing music", "calm nature sounds", "soothing piano music",
    //                "ambient background", "neutral mood playlist", "serene ocean waves",
    //                "minimalist vlogs", "quiet library ambiance", "forest rain sounds", "evening chill beats"
    //            ],
    //            "sad": [
    //                "uplifting music", "inspiring talks", "funny animal videos",
    //                "relaxing jazz", "happy moments compilation", "hopeful stories",
    //                "self-care routines", "heartwarming scenes", "positive journaling", "laugh therapy"
    //            ]
    //        ]
    //
    //        // MARK: - Default Video Topics
    //        // Fallback video topics in case the mood is not found in the dictionary
    //        let defaultTopics = [
    //            "happy vibe playlist", "motivational talks", "funny animal videos",
    //            "relaxing music", "positive energy playlist", "serene nature scenes",
    //            "feel good videos", "comforting soundscapes", "morning inspiration", "peaceful views"
    //        ]
    //
    //        // Fetch the list of topics based on the predicted mood or use default topics if mood isn't found
    //        let topics = moodTopics[viewModel.predictedMood] ?? defaultTopics
    //
    //        // MARK: - Randomized Topic Selection
    //        // Returns a randomized selection of up to 5 topics for variety
    //        return getRandomTopics(from: topics, count: 5)
    //    }
    //
    //    // MARK: - Random Topics Helper Function
    //    // Helper function that shuffles the provided topics and returns a specified number of items
    //    private func getRandomTopics(from topics: [String], count: Int) -> [String] {
    //        return Array(topics.shuffled().prefix(count))
    //    }
    
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
