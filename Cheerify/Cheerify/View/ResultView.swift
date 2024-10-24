import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        ZStack {
            
            //  BGM
            AppColors.gradientBGM_topShadow
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Your Mood Today!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Mood Image based on the prediction
                Image(moodImageName())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                // Note based on the predicted mood
                Text(moodNote())
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text(viewModel.resultText) // You can keep this to display classification details
                    .font(.headline)
                    .padding()
                
                Spacer() // To push the content to the top and leave space at the bottom
            }
            .padding()
        }
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
