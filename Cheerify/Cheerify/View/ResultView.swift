import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoodViewModel
    @StateObject private var profileVM = ProfileViewModel()
    @State private var isSaved = false
    
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
                Text("Your Mood Today!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                
                // Mood Image based on the prediction
                Image(moodImageName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                // Note based on the predicted mood
                Text(moodNote())
                    .font(.title3)
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text(viewModel.resultText) // You can keep this to display classification details
                    .font(.headline)
                    .foregroundStyle(profileVM.isDarkMode ? .white : .black)
                    .padding()
                
                Spacer() // To push the content to the top and leave space at the bottom
                
                // I need this button in order to show it in the HomeView - Olivia
                Button(isSaved ? "Saved" : "Save Mood") {
                    saveMoodResult()
                    isSaved = true // Change the label after saving
                }
                .font(.headline)
                .padding()
                .background(isSaved ? Color.gray : Color.customOrange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func saveMoodResult() {
        let mood = viewModel.predictedMood
        let note = moodNote()
        let imageName = moodImageName()
        let date = Date()
        
        PersistenceController.shared.saveMood(mood: mood, note: note, imageName: imageName, date: date)
    }
    
    // Function to map mood to image asset name
    func moodImageName() -> String {
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
            return "happyOctopus" // Default image
        }
    }
    
    
    // Function to map mood to note text
    func moodNote() -> String {
        switch viewModel.predictedMood {
        case "happy":
            return "We have a happy octopus here ♥️"  // Note for happy
        case "fear":
            return "What’s making your heart race right now?" // Note for fear
        case "angry":
            return "Seems like everything’s been pushing your limits todayyy" // Note for angry
        case "neutral":
            return "Today seems to have its ups and downs for you 🫂" // Note for neutral
        case "sad":
            return "aww, why you are a sad apple today ?" // Note for sad
        default:
            return "We have a happy octopus here ♥️"  // Default note
        }
    }
}

#Preview {
    ResultView(viewModel: MoodViewModel())
}
