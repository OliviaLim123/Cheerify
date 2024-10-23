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
                
                Text(viewModel.resultText)
                    .font(.headline)
                    .padding()
                
                // Additional content here (recommendations, etc.)
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
}

#Preview {
    ResultView(viewModel: MoodViewModel())
}
